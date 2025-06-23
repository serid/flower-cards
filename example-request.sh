curl "https://api.groq.com/openai/v1/chat/completions" \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d '{
         "messages": [
           {
             "role": "user",
             "content": "Translate ONLY the bracketed word in a given sentence to Hungarian. Output ONLY the Hungarian equivalent.\nSentence: \"Doge is the most [[[beautiful]]] gift.\""
           },
           {
             "role": "assistant",
             "content": "legszebb"
           },
           {
             "role": "user",
             "content": "Sentence: \"I [[[study]]] at the library.\""
           }
         ],
         "model": "gemma2-9b-it",
         "temperature": 0,
         "max_completion_tokens": 16,
         "top_p": 1,
         "stream": false,
         "stop": null
       }'