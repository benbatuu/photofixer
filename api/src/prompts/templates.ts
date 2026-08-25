import type { PhotoOperation } from '../types.js';

const identityGuard = `
Preserve the identity, composition, facial structure, skin texture, clothing,
objects, and scene. Do not invent or replace facial features. Do not change the
person's identity. Do not add or remove objects. Do not change the composition.
The output should look like a professionally corrected photograph, not an
AI-generated reinterpretation.
`.trim();

export function promptFor(operation: PhotoOperation): string {
  switch (operation) {
    case 'enhance':
      return `
Enhance the provided photograph.
Improve exposure, contrast, white balance, sharpness and overall clarity.
Reduce noise and compression artifacts.
${identityGuard}
`.trim();
    case 'relight':
      return `
Correct the lighting of the provided photograph.
Improve exposure, shadows, highlights and white balance.
Create natural-looking illumination. Do not over-smooth skin.
${identityGuard}
`.trim();
    case 'restore':
      return `
Restore this old or degraded photograph.
Reduce scratches, noise, compression artifacts and degradation.
Improve clarity while keeping the result faithful to the original.
Do not modernize the scene.
${identityGuard}
`.trim();
    case 'unblur':
      return `
Improve the apparent sharpness and clarity of this photograph without inventing
important visual details. Reduce motion blur and softness where possible.
Do not hallucinate facial details. Do not promise perfect recovery of lost information.
${identityGuard}
`.trim();
  }
}
