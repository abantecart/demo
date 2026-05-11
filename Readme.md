Repository for abantecart_demo on Docker Hub

Update to new version of Abantecart.

### Variant 1: 

1. Clone repo.
2. Move to directory 'demo/docker'
3. Build image:
```
docker build -t abantecart/abantecart_demo ./
``` 
4. Show all images to check if image is built:
```
docker images
```
5. Login Docker Hub
```
docker login
```
6. Push image to Docker Hub
```
docker push abantecart/abantecart_demo
```

### Variant 2:

1. Clone repo.
2. Move to directory 'demo/docker'
3. Build image & push image:

```docker buildx build --platform linux/amd64,linux/arm64 -t abantecart/abantecart_demo:latest --push ./```


### Note:    
demo.abantecart.com will be updated in 30 min.
