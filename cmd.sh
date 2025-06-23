curl "https://api.groq.com/openai/v1/chat/completions" \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${GROQ_API_KEY}" \
  -d '{
         "messages": [
           {
             "role": "user",
             "content": "Read this sentence and translate the word in braces to Hungarian. Do NOT format or explain your answer, just reply with a single noun or noun phrase.\n\"Doge is the most [[[beautiful]]] gift from God.\""
           }
         ],
         "model": "gemma2-9b-it",
         "temperature": 0,
         "max_completion_tokens": 16,
         "top_p": 1,
         "stream": false,
         "stop": null
       }'