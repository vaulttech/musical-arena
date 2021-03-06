
uniform mat4 mWorldViewProjP;
uniform float sinWaveP;
uniform float refractionP;
uniform float seaLevel;
uniform sampler2D ReflectionTexture;
uniform sampler2D NormalMap;
uniform sampler2D DUDVMap;


varying vec4 waterPos;
varying vec3 MultiVar;
varying vec3 worldView;
varying vec2 texCoords;

void main() {

    vec4 projCoord=mWorldViewProjP*waterPos;
    projCoord.x=(projCoord.x/projCoord.w)/2.0+0.5;
    projCoord.y=(projCoord.y/projCoord.w)/2.0+0.5;

    if(sinWaveP>0.0) {

        projCoord.x+=sin(MultiVar.x*5.0)*(2.0/1000.0);
        projCoord.y+=cos(MultiVar.x*5.0)*(2.0/1000.0);
        texCoords.x+=sin(MultiVar.x*5.0)*(5.0/1000.0);
        texCoords.y+=cos(MultiVar.x*5.0)*(5.0/1000.0);

    }

    if(refractionP>0.0) {

        vec4 DUDVoffset=texture2D(DUDVMap, texCoords);
        projCoord.x+=(DUDVoffset.x/40.0)-(1.0/80.0);
        projCoord.y+=(DUDVoffset.y/40.0)-(1.0/80.0);

    }

    projCoord=clamp(projCoord, 0.001, 0.999);

    vec4 normal=vec4(0.0,1.0,0.0,0.0);

    if(MultiVar.z<seaLevel) projCoord.y=1.0-projCoord.y;

    projCoord.y*=-1;
    vec4 refTex=texture2D(ReflectionTexture, projCoord.xy);

    float facing=(1.0-max(dot(normalize(worldView), normalize(normal.xyz)), 0.0));
    vec4 MultCol=vec4(0.4,0.7,1.0,0.0);
 
    refTex=(refTex+vec4(0.0,0.0,0.1,0.0))*MultCol;

    vec4 norMap=texture2D(NormalMap, texCoords);
    float lightComp=1.0-max(dot(normalize(norMap.xyz), normalize(abs(worldView))),0.0);

    vec4 finalCol=refTex;

    if(MultiVar.z<seaLevel) finalCol*=0.8;

    finalCol.a=0.6+(facing/2.0);
    finalCol+=lightComp;

    gl_FragColor=finalCol;

}



