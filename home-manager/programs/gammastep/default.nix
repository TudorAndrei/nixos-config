{pkgs, ...}: {


services.gammastep = {
  enable = true;
  provider = "manual";
  latitude = 44.426765;
  longitude = 26.102537;
  
};
}
