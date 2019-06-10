class Brain{
  ArrayList<NeuralLayer> neuralNet = new ArrayList<NeuralLayer>();
  Dino brainsDino;
  
  Brain(Dino myDino){
    brainsDino = myDino;
    
    neuralNet.add(new NeuralLayer(8, true, null)); //initializes input layer with 8 nodes
    
    neuralNet.add(new NeuralLayer(3, false, neuralNet.get(0))); //initializes hidden layer with 3 nodes
    
    neuralNet.add(new NeuralLayer(4, false, neuralNet.get(1))); //initializes output layer with 4 nodes

    
  }
  
  Brain clone(Dino cloneDino){
    Brain clone = new Brain(cloneDino);
    
    clone.neuralNet.set(0, neuralNet.get(0).clone(null));
    for(int i = 1; i < neuralNet.size(); i++){
      clone.neuralNet.set(i, neuralNet.get(i).clone(clone.neuralNet.get(i - 1)));
    }
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
    
    for(int j = 0; j < neuralNet.get(numLayers - 1).size; j++){ //for each node in the final layer
      
      if(neuralNet.get(numLayers - 1).activations[j] >= max){ //if current node has highest activation so far
        max = neuralNet.get(numLayers - 1).activations[j]; //set max to the activation of current node
        ind = j; //
      }
    }
    //Causes the neural net to give a "response"
    return ind;
  }
  

}
