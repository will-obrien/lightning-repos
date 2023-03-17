class Car{ 
  
  private String make;
  private String year;
  
  public void createCar(String z, String x){ 
    Car c = (Car)JSON.deserializeStrict(
      '{"make":"'+ z + '","year":"' + x + '"}', Car.class);   //Bad: Unknown inputs are used to create the object.
  }
  
  public void badParam(Integer param){
    param=5;
  }
}
