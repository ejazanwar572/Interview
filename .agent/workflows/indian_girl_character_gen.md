---
description: generate consistent ultra-realistic indian girl character
---

1. When the user invokes this workflow, use the `generate_image` tool to create new images.
2. If this workflow is invoked, use the following master character prompt to maintain consistency:
   "A highly realistic photo of a specific Indian girl. She has natural, medium-brown skin with very mild, subtle acne spots and a light pink blush on her cheeks. She has realistic skin texture with visible pores and slight natural shine on her nose tip and cheekbones. She has big dark brown eyes with clear light reflections, dark thick eyebrows, and dark hair. Her lips are slightly full."
3. If the user specifies an action or pose (e.g., "pouting", "smiling", "drinking coffee", "sitting in a cafe"), incorporate that into the prompt, modifying her expression or setting accordingly.
4. If available, use the previous generated image as an input image in the `ImagePaths` array (e.g. `/Users/ejazanwar/.gemini/antigravity/brain/c25929be-0967-4895-8470-3b9cb60676d1/indian_girl_ultra_realistic_clean_phone_1771634827714.png`) to help maintain extreme consistency.
5. Provide the generated image to the user and ask if any further adjustments are needed.
