"""
Hexaware Technologies - Practical Agentic AI Training
Day 1 - Module 3: Offline RAG (Retrieval-Augmented Generation)

This script demonstrates:
1. Loading configuration from .env file (OLLAMA_MODEL, EMBEDDING_MODEL, SOP_DOCUMENT_PATH).
2. Loading local enterprise documentation.
3. Chunking text with overlap to preserve semantic context.
4. Generating vector embeddings locally with Sentence-Transformers.
5. Performing cosine similarity vector search.
6. Assembling grounded context for local Ollama LLM response generation with citation.
"""

import os
import sys
import numpy as np
from dotenv import load_dotenv
from sentence_transformers import SentenceTransformer
import ollama

# Load environment variables
load_dotenv()

MODEL_NAME = os.getenv("OLLAMA_MODEL", "llama3.2:1b")
EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "all-MiniLM-L6-v2")

# Resolve document path relative to script or workspace root
default_doc = os.path.join(os.path.dirname(__file__), "mock_hexaware_enterprise_guide.txt")
DOC_PATH = os.getenv("SOP_DOCUMENT_PATH", default_doc)
if not os.path.exists(DOC_PATH):
    DOC_PATH = default_doc


class LocalVectorStore:
    """Lightweight offline local vector database using Sentence-Transformers."""
    def __init__(self, model_name: str = EMBEDDING_MODEL):
        print(f"Loading local embedding model: [{model_name}]...")
        self.encoder = SentenceTransformer(model_name)
        self.chunks = []
        self.embeddings = None

    def add_documents(self, text_chunks: list[str]):
        self.chunks = text_chunks
        print(f"Generating embeddings for {len(text_chunks)} text chunk(s)...")
        raw_embs = self.encoder.encode(text_chunks, convert_to_numpy=True, normalize_embeddings=True)
        self.embeddings = raw_embs
        print("Embeddings stored in local vector store.")

    def search(self, query: str, top_k: int = 2) -> list[tuple[str, float]]:
        query_emb = self.encoder.encode([query], convert_to_numpy=True, normalize_embeddings=True)[0]
        # Cosine similarity for normalized vectors is simply the dot product
        scores = np.dot(self.embeddings, query_emb)
        ranked_indices = np.argsort(scores)[::-1][:top_k]
        return [(self.chunks[i], float(scores[i])) for i in ranked_indices]


def chunk_text(text: str, chunk_size: int = 400, overlap: int = 60) -> list[str]:
    """Split raw text into overlapping paragraphs/chunks."""
    paragraphs = [p.strip() for p in text.split("\n\n") if p.strip()]
    chunks = []
    current_chunk = ""

    for p in paragraphs:
        if len(current_chunk) + len(p) < chunk_size:
            current_chunk += ("\n\n" if current_chunk else "") + p
        else:
            if current_chunk:
                chunks.append(current_chunk)
            current_chunk = p
    if current_chunk:
        chunks.append(current_chunk)
    return chunks


def run_rag_pipeline(query: str):
    print("=" * 65)
    print(" HEXAWARE OFFLINE RAG PIPELINE")
    print(f" LLM Model: [{MODEL_NAME}] | Embedding: [{EMBEDDING_MODEL}]")
    print(f" Target SOP Document: [{DOC_PATH}]")
    print("=" * 65)

    # 1. Load Document
    if not os.path.exists(DOC_PATH):
        print(f"Document not found at: {DOC_PATH}")
        return

    with open(DOC_PATH, "r", encoding="utf-8") as f:
        raw_doc = f.read()

    print(f"1. Ingested Document ({len(raw_doc)} characters)")

    # 2. Chunking
    chunks = chunk_text(raw_doc, chunk_size=500, overlap=50)
    print(f"2. Created {len(chunks)} overlapping chunk(s)")

    # 3. Embed & Index
    vstore = LocalVectorStore()
    vstore.add_documents(chunks)

    # 4. Query Retrieval
    print(f"\n3. Executing Vector Similarity Search for Query: '{query}'")
    results = vstore.search(query, top_k=2)

    context_blocks = []
    for rank, (chunk, score) in enumerate(results, 1):
        print(f"\n[Retrieved Chunk #{rank} | Similarity: {score:.4f}]:\n{chunk[:180]}...")
        context_blocks.append(chunk)

    combined_context = "\n\n---\n\n".join(context_blocks)

    # 5. Augmented Generation with Ollama
    print("\n" + "=" * 65)
    print(f"4. Grounded Generation with Local LLM ({MODEL_NAME})")
    print("=" * 65)

    system_prompt = """You are HexaSupport, an AI operations engineer at Hexaware Technologies.
Answer the user's question accurately using ONLY the provided SOP context.
If the answer cannot be determined from the context, state that clearly.
Always cite the relevant SOP section in your answer."""

    user_prompt = f"""CONTEXT FROM HEXAWARE SOP:
{combined_context}

USER QUESTION:
{query}"""

    response = ollama.chat(
        model=MODEL_NAME,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ],
        options={"temperature": 0.1}
    )

    print("\nSynthesized Answer:\n")
    print(response["message"]["content"].strip())


if __name__ == "__main__":
    test_query = "What is the mandatory autonomous agent action for a Severity 1 incident and what is the resolution target SLA?"
    run_rag_pipeline(test_query)
