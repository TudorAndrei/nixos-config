{pkgs, ...}: {


services.redshift = {
  enable = true;
  temperature = {
    day = 5700;
    night = 3500;
  };
  latitude = "44.426765";
  longitude = "26.102537";
  brightness = {
    day = "1";
    night = "0.8";
  };
  
};
}
