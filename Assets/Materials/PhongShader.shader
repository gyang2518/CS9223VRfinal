Shader "Unlit/PhongShader"{
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1) //The color of our object
        _Tex ("Pattern", 2D) = "white" {} //Optional texture

        _Shininess ("Shininess", Float) = 10 //Shininess
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
    }
    SubShader {
        Tags { "RenderType" = "Opaque" } //We're not rendering any transparent objects
        LOD 200 //Level of detail

        Pass {
            Tags { "LightMode" = "ForwardBase" } //For the first light

            CGPROGRAM
                #pragma vertex vertShader
                #pragma fragment fragShader

                #include "UnityCG.cginc" //Provides us with light data, camera information, etc

                uniform float4 _LightColor0;

                sampler2D _Tex; //Used for texture
                float4 _Tex_ST; //For tiling

                uniform float4 _Color; 
                uniform float4 _SpecColor;
                uniform float _Shininess;

                struct vInput
                {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct vOutput
                {
                    float4 pos : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                    float4 posWorld : TEXCOORD1;
                };

                vOutput vertShader(vInput v)
                {
                    vOutput curr;

                    curr.posWorld = mul(unity_ObjectToWorld, v.vertex); 
                    curr.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz); 
                    curr.pos = UnityObjectToClipPos(v.vertex);
                    curr.uv = TRANSFORM_TEX(v.uv, _Tex);

                    return curr;
                }

                fixed4 fragShader(vOutput finput) : COLOR
                {
                    float3 tex = tex2D(_Tex, finput.uv)
                    float3 normalDirection = normalize(finput.normal);
                    float3 viewDirection = normalize(_WorldSpaceCameraPos - finput.posWorld.xyz);

                    float3 vert2LightSource = _WorldSpaceLightPos0.xyz - finput.posWorld.xyz;
                    float oneOverDistance = 1.0 / length(vert2LightSource);
                    float3 lightDirection = _WorldSpaceLightPos0.xyz - finput.posWorld.xyz * _WorldSpaceLightPos0.w;

                    float3 I_amb = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb; //Ambient component
                    float3 I_diff =  _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); //Diffuse component
                    float3 I_spec;
                    
                    // sphere transformation
                    if (dot(finput.normal, lightDirection) < 0.0) //Light on the wrong side - no specular
                    {
                        I_spec = float3(0.0, 0.0, 0.0);
                	  }
                    else
                    {
                        //Specular component
                        I_spec = _LightColor0.rgb * _SpecColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
                    }

                    float3 color = (I_amb + I_diff) * tex + I_spec; 
                    return float4(color, 1.0);
                }
            ENDCG
        }
    }
}