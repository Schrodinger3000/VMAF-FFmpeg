# VMAF-FFmpeg
Docker file to build a ffmpeg image under Ubuntu with the external libvmaf of Netflix VMAF Open Source

## Build
```
docker build -t ffmpeg .
```

## Usage
### Mac
This command will bind the shell's current directory to the container and will be able to read/write
```
docker run -v `pwd`:`pwd` -w `pwd` ffmpeg -i <input> <args> <output>
```

## Example using vmaf
4K Model with scaling
```
docker run -v `pwd`:`pwd` -w `pwd` ffmpeg -i transcoded.mp4 -i source.mov -an -filter_complex "[0:v]scale=1920x1080:flags=bicubic[main];[main][1:v]libvmaf=model_path=vmaf_4k_v0.6.1.pkl" -f null -
```

Default Model
```
docker run -v `pwd`:`pwd` -w `pwd` ffmpeg -i transcoded.mp4 -i source.mov -an -filter_complex "[0:v]scale=1920x1080:flags=bicubic[main];[main][1:v]libvmaf=model_path=vmaf_v0.6.1.pkl" -f null -
```

Phone Model
```
docker run -v `pwd`:`pwd` -w `pwd` ffmpeg -i transcoded.mp4 -i source.mov -an -filter_complex "[0:v]scale=1920x1080:flags=bicubic[main];[main][1:v]libvmaf=model_path=vmaf_v0.6.1.pkl:phone_model=1" -f null -
```

## See what's inside
This will open a shell inside
```
docker exec --entrypoint bash -v `pwd`:`pwd` -w `pwd` ffmpeg
```

### Models
Models live in
```
/usr/local/share/model
```