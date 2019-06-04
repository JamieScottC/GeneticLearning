class NeuralLayer{
  int[] biases;
  double[] activations;
  double[][] weights;
  
  boolean input;
  
  int size;
  
  NeuralLayer lastNL;
  
  NeuralLayer(int siz, boolean inp, NeuralLayer last){
    input = inp;
    size = siz;
    
    if(!inp){
      lastNL = last;
      weights = new double[size][lastNL.size];
    }
    
    biases = new int[size];
    activations = new double[size];
    
    if(gen == 0){
      randomize();
    }else{
    
    }
    
  }

  void activationFunction(Dino ourDino){
    if(input){
      activations = getData(ourDino);
    }
    else{
      for(int i = 0; i < size;i++){
        double sum = 0;
        for(int j = 0; j < lastNL.size; j++){
          sum += (lastNL.activations[j]) * (weights[i][j]) + biases[i]; //FIX BY SETTING ARRAY BEFORE, AND GRABBING HERE
        }
        
        sum = sigmoid(sum);
        append(activations, sum);
      } 
    }
    
  }
  
  void randomize(){
    for(int i = 0; i < size; i++){
      biases[i] = Math.round(random(0, 10));
      for(int j = 0; j < weights[0].length; j++){
        weights[i][j] = random(-10, 10);
      }
    }
  }
  
  double[] getActivations(){
    return activations;
  }
  
  void mutate(){
    for(int i = 0; i < size; i++){
      biases[i] += Math.round(random(-2, 2));
      for(int j = 0; j < weights[0].length; j++){
        weights[i][j] *= random(0.9, 1.1);
      }
    }
  
  }
  
}
