Repository for abantecart_demo on Docker Hub

Update to new version of Abantecart.

1. Clone code.
2. Move to directory 'demo'
3. Build image:
```
docker build ./
``` 
4. Show all images 
```
docker images
```
5. Find latest and tag them 
```
docker tag [IMAGE_ID] abantecart/abantecart_demo
```
6. Login Docker Hub
```
docker login
```
7. Push image to Docker Hub
```
docker push abantecart/abantecart_demo
```

demo.abantecart.com will be updated in 30 min.