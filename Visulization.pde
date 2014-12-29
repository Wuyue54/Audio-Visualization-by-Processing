import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.opengl.*;
Minim minim;
AudioPlayer song;
AudioInput input;
FFT fft;

float rX = 0;
float rY = 0;
float vX = 0;
float vY = 0;
float num=1;
int sampleRate=1024;

float[][] asd=new float[60][1024];

void setup(){
  size(1200,900,OPENGL);
  smooth();
  noFill();
  minim=new Minim(this);
  song=minim.loadFile("4.mp3",sampleRate);
  input=minim.getLineIn();
  song.play();
  fft = new FFT(song.bufferSize(), song.sampleRate());
  for(int i=0;i<55;i++){
     for(int j=0;j<1024;j++){
       asd[i][j]=height/3;
     }
   }
   
   colorMode(HSB,360,100,100);
}

void draw(){
  background(0);
  translate(width/3,height/4,-50);
  rotateX( radians(rX) );  
  rotateY( radians(rY) );
  scale(num);
  
  rX += vX;
  rY += vY;
  vX *= 0.95;
  vY *= 0.95;
  if(mousePressed){
    vX += (mouseY-pmouseY) * 0.01;
    vY -= (mouseX-pmouseX) * 0.01;
  }
 

  fft.forward(song.mix);
  for(int j=0;j<55;j++){
  for(int i = 0; i < fft.specSize(); i++)
  {
    //println(fft.specSize());
    asd[j][i]=asd[j+1][i];
   
  } if(j==55){
      j=0;
    }
  }


  for(int i = 0; i < fft.specSize(); i++){
    asd[54][i]=height/3 - fft.getBand(i)*4;
  }
for(int i=0;i<55;i++){
  for(int j=0;j<fft.specSize();j+=10){
    stroke(j*0.7-5,100,100);
    //stroke(255);
 //   line(j*3,height/3,i*8,j*3,asd[i][j],i*8);
    line(j-(fft.specSize())/20,height/3,(i-22)*12,j-(fft.specSize())/20,asd[i][j],(i-22)*12);
  //  stroke(0,0,99);
 // stroke(0);
  fill(j*0.7,100,100);
  pushMatrix();
  //translate(j*3,asd[i][j],i*8);
  translate(j-(fft.specSize())/20,asd[i][j],(i-22)*12);
  box(10);
  popMatrix();
    //point(j*3,asd[i][j],i*8);
  }
}
}
