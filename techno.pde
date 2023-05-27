import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.core.PApplet;

Minim minim;
AudioInput audioInput;
BeatDetect beatDetect;

int numLines = 100; // Number of lines
float[] lineHeights;
float lineWidth;
float lineHeight;

void setup() {
  size(800, 600);
  frameRate(30);
  colorMode(HSB, 360, 100, 100);
  blendMode(ADD);
  strokeWeight(2);

  minim = new Minim(this);
  audioInput = minim.getLineIn(Minim.MONO, 1024);
  beatDetect = new BeatDetect();

  lineWidth = width / (numLines - 1);
  lineHeight = height * 0.9f; // Increased bar height

  lineHeights = new float[numLines];
}

void draw() {
  background(0);

  // Analyze audio input
  beatDetect.detect(audioInput.mix);
  float[] audioData = audioInput.mix.toArray();

  // Update line heights based on audio energy
  for (int i = 0; i < numLines; i++) {
    int index = PApplet.floor(map(i, 0, numLines - 1, 0, audioData.length - 1));
    float energy = abs(audioData[index]);
    lineHeights[i] = lerp(lineHeights[i], energy * lineHeight, 0.2);
  }

  // Draw lines
  for (int i = 0; i < numLines; i++) {
    float lineColor = map(i, 0, numLines - 1, 0, 360);
    stroke(lineColor, 100, 100, 50); // Add transparency for fading effect
    float x = i * lineWidth;
    line(x, height, x, height - lineHeights[i]);

    // Add additional effects
    float noiseValue = noise(frameCount * 0.01 + i * 0.2);
    float noiseOffset = map(noiseValue, 0, 1, -10, 10);
    translate(x + lineWidth / 2, height - lineHeights[i]);
    rotate(noiseOffset);
    scale(1 + noiseOffset * 0.02);
    line(-lineWidth / 2, 0, lineWidth / 2, 0);
    resetMatrix();
  }
}
