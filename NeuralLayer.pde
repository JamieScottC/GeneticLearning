class NeuralLayer{
  int[] biases;
  float[] activations;
  float[][] weights;
  
  boolean input;
  
  int size;
  
  NeuralLayer lastNL;
  
  NeuralLayer(int siz, boolean inp, NeuralLayer last){
    input = inp;
    size = siz;
    
    if(!inp){
      lastNL = last;
      weights = new float[size][lastNL.size]; 
      
      biases = new int[size];
      activations = new float[size];
      
      randomize();
    }
    
  }
  
  NeuralLayer clone(NeuralLayer lastOne){
    NeuralLayer clone = new NeuralLayer(size, input, lastOne);
    
    if(!input){
      for(int i = 0; i < size; i++){
        clone.biases[i] = biases[i];
      }
      for(int j = 0; j < size; j++){
        for(int k = 0; k < weights[0].length; k++){
          clone.weights[j][k] = weights[j][k];
        }
      }
    }
    
    return clone;
  }

  void activationFunction(Dino ourDino){
    if(input){
      activations = getData(ourDino);
    }
    else{
      for(int i = 0; i < size; i++){ //for each node in layer
        float sum = 0; //var sum = 0

        for(int j = 0; j < lastNL.size; j++){ //for each node in previous layer
          sum += ((lastNL.activations[j]) * (weights[i][j])) + biases[i]; //add to sum: previous node activation * weight for this node connected to previous node + bias  
        }
        
        sum = sigmoid(sum);
        
        activations[i] = sum;
      } 
    }
    
  }
  
  void randomize(){
    for(int i = 0; i < size; i++){
      biases[i] = 0;
      for(int j = 0; j < lastNL.size; j++){
        weights[i][j] = random(-5, 5);
      }
    }
    
  }
  
  void mutate(){
    float lower;
    float higher;
    if(bestScore > lastScore){
      lower = 0.8;
      higher = 1.2;
    }else{
      lower = 0.9;
      higher = 1.1;
    }
    
    for(int i = 0; i < size; i++){
      biases[i] += Math.round(random(-1, 1));
      for(int j = 0; j < weights[0].length; j++){
        weights[i][j] *= random(lower, higher);
        if(random(1) < 0.1){
          weights[i][j] *= -1;
        }
      }
    }
  
  }
  
}
