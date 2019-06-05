class Brain{
  ArrayList<NeuralLayer> neuralNet = new ArrayList<NeuralLayer>();
  Dino brainsDino;
  
  
  Brain(Dino myDino){
    brainsDino = myDino;
    
    neuralNet.add(new NeuralLayer(6, true, null)); //initializes input layer with 8 nodes
    if(gen < 5){
      neuralNet.add(new NeuralLayer(2, false, neuralNet.get(0))); //initializes output layer with 2 node
    }
    else if(gen < 10){
      neuralNet.add(new NeuralLayer(3, false, neuralNet.get(0))); //initializes output layer with 3 nodes 
    }
    else if(gen < 15){
      neuralNet.add(new NeuralLayer(4, false, neuralNet.get(0))); //initializes output layer with 4 nodes 
    }
    else{
      neuralNet.add(new NeuralLayer(3, false, neuralNet.get(0))); //initializes hidden layer with 3 nodes
      neuralNet.add(new NeuralLayer(4, false, neuralNet.get(1))); //initializes output layer with 4 nodes
    }  
    
  }
  
  Brain clone(Dino cloneDino){
    Brain clone = new Brain(cloneDino);
    clone.neuralNet.
    
    return clone;
  }
  
  public NeuralLayer getLastNL(int ind){
    if(ind == 0){
      return neuralNet.get(0);
    }
    return neuralNet.get(ind - 1);
  
  }
  
  int fireTheNet(){
    int numLayers = neuralNet.size();
    float max = 0;
    int ind = 0;
    
    for(int i = 0; i < numLayers; i++){
      neuralNet.get(i).activationFunction(brainsDino);
    }
    
    //println(neuralNet.get(numLayers - 1).activations);
    
    for(int j = 0; j < neuralNet.get(numLayers - 1).size; j++){ //for each node in the final layer
      //println("I'm node" + j + " my activation is: " + neuralNet.get(numLayers - 1).activations[j]);
      if(neuralNet.get(numLayers - 1).activations[j] > max){ //if current node has highest activation so far
        max = neuralNet.get(numLayers - 1).activations[j]; //set max to the activation of current node
        ind = j; //
        //println("ive found a higher activation");
      }
    }
    //Causes the neural net to give a "response"
    return ind;
  }
  

}
