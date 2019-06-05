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
      //println(weights[i]);
    }
    
  }
  
  void mutate(){
    for(int i = 0; i < size; i++){
      biases[i] += Math.round(random(-1, 1));
      for(int j = 0; j < weights[0].length; j++){
        weights[i][j] *= random(0.8, 1.2);
      }
    }
  
  }
  
}
