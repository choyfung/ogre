#version 120
varying vec2 oUv0;

uniform sampler2D mrt1;

uniform float stepX;
uniform float cKernelWidthBias;

void main()
{
    const int kernelWidth = 19;
    float sigma = (kernelWidth - 1) / 6; // make the kernel span 6 sigma

    float weights = 0;
    float blurredDepth = 0;
    
    for (float i = -(kernelWidth - 1) / 2; i < (kernelWidth - 1) / 2; i++)
    {
        float geometricWeight = exp(-pow(i, 2) / (2 * pow(sigma, 2)));
        weights += geometricWeight;
        blurredDepth += texture2D(mrt1, vec2(oUv0.x - i * stepX * cKernelWidthBias, oUv0.y)).w * geometricWeight;
    }

    blurredDepth /= weights;
    gl_FragColor = vec4(texture2D(mrt1, oUv0).xyz, blurredDepth);
}