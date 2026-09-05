screengrab() {
  VIDDIR=$HOME/Videos/Screengrabs
    [ ! -d "$VIDDIR" ] && mkdir "$VIDDIR"
    RES=$(xrandr | grep \* | awk '{print $1}')
      ffmpeg -y -f x11grab -video_size "$RES" -framerate 30 -i :0.0 -f pulse -ac 2 -i 0 -c:v libx264 -pix_fmt yuv420p -s "$RES" -preset ultrafast -c:a libfdk_aac -b:a 128k -threads 0 -strict normal -bufsize 2000k "$VIDDIR"/"$1".mp4
}
