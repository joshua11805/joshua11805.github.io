//
//  FirstShader.metal
//  HealthQuest
//
//  Created by JoshuaShin on 12/4/24.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 passthrough(float2 pos, half4 color){
    return color;
}


