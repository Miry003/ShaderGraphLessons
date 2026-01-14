Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Vel("Velocity", Float) = 2.0
        _Expansion("Espansione", Range(0,0.5)) = 0.2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL; 
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Vel; 
            float _Expansion;

            v2f vert (appdata v)
            {
                float oscillazione = sin(_Time.y * _Vel) *0.5 + 0.5;
                v.vertex.xyz += v.normal * oscillazione * _Expansion;

                v2f o;
                //trasforma la posizione del vertice im clip space
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
               // fixed4 col = tex2D(_MainTex, i.uv);
              // fixed4 col = fixed4(1,0,0,1);
               float oscillazione = sin( _Time.y * _Vel );
               float redValue = oscillazione *0.5 + 0.5; 
               //metto il redvalue al posto di 1
               fixed4 col = fixed4(redValue,0,0,1);
               return col;
            }
            ENDCG
        }
    }
}
