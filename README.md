# Parallelbeam CT

### Reference 
[Computed Tomography: Principles, Design, Artifacts, and Recent Advances, 3rd.](http://bitly.kr/SOw7Yb1s)

    Please read Chapter 3. Image Reconstruction.

### Abstract
X-ray computed tomography (CT) has experienced an explosion of technological development for a quarter century. Six years after the second edition of Computed Tomography, this third edition captures the most recent advances in technology and clinical applications. New to this edition are descriptions of iterative reconstruction, statistical reconstruction, methodologies used to model the CT systems, and the searching methodologies for optimal solutions. A new section on 3D printing introduces approaches by early adopters in the area. Also added is a description and discussion of the size-specific dose estimate, an index that attempts to more accurately reflect the dose absorption of specific-sized patients. The coverage of dual-energy CT has been significantly expanded to include its background, theoretical development, and clinical applications.
      
## Projection
* Projection operator is implemented based on Ch.3 Equation (3.5) & (3.6).
* Ray-driven method is applied to Projection operator.

    * Ch.3 Equation (3.5): `Rotated coordinate` X-ray CT system (`Counterclockwise`).
        * ![eq-t-axis](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20t%20%3D%20x%20%5Ccos%28%5Ctheta%29%20&plus;%20y%20%5Csin%28%5Ctheta%29)
        * ![eq-s-axis](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20s%20%3D%20-x%20%5Csin%28%5Ctheta%29%20&plus;%20y%20%5Ccos%28%5Ctheta%29)

    * Ch.3 Equation (3.6): `Line integration` along X-ray.
        * ![eq-line-integration](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20p%28t%2C%5Ctheta%29%20%3D%20%5Cint_%7B-%5Cinfty%7D%5E%7B&plus;%5Cinfty%7Df%27%28t%2Cs%29%20ds)

## Filtering
* Filtering operator is implemented based on Ch.3 Equation (3.28) & (3.29) & (3.30).

* `Filtering kernel` is generated by Equation (3.29).
    * ![eq-filtering-kernel](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20h%28n%5Cdelta%29%20%3D%20%5Cleft%5C%7B%5Cbegin%7Bmatrix%7D%20%5Cfrac%7B1%7D%7B4%5Cdelta%5E2%7D%2C%20%26%20n%3D0%2C%7E%7E%7E%5C%5C%200%2C%20%26%20n%3Deven%2C%5C%5C%20-%20%5Cfrac%7B1%7D%7B%28n%5Cpi%5Cdelta%29%5E2%7D%20%2C%20%26%20n%3Dodd.%7E%20%5Cend%7Bmatrix%7D%5Cright.)
        
* Filtering is performed by `convolution ver.` using Ch.3 Equation (3.30) and `FFT ver.` using Equation (3.28).
    * Ch.3 Equation (3.30): `convolution ver.` 
        * ![eq-convolution](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20f%28x%2Cy%29%3D%5Cint_%7B0%7D%5E%7B%5Cpi%7Dd%5Ctheta%5Cint_%7B-t_%7Bm%7D%7D%5E%7B&plus;t_%7Bm%7D%7D%7Bp%28t%27%2C%20%5Ctheta%29h%28t-t%27%29dt%27%7D)
    * Ch.3 Equation (3.28): `FFT ver.`
        * ![eq-FFT](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20g%28n%5Cdelta%2C%5Ctheta%29%3D%5Cdelta%5Csum_%7Bk%3D0%7D%5E%7BN-1%7D%7Bh%28n%5Cdelta-k%5Cdelta%29p%28k%5Cdelta%2C%20%5Ctheta%29%2C%7D%7E%7En%3D0%2C1%2C%5Ccdots%2CN-1)

## Backprojection
* Backprojection operator is implemented based on Ch.3 Equation (3.22).
* Pixel-driven method is applied to backprojection operator.

    * Ch.3 Equation (3.22): `Backprojection`
        * ![eq-backprojection](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20f%28x%2C%20y%29%20%3D%5Cint_%7B0%7D%5E%7B%5Cpi%7Dg%28x%20%5Ccos%28%5Ctheta%29%20&plus;%20y%5Csin%28%5Ctheta%29%29d%5Ctheta)
        
## Parameters
* X-ray CT System parameters
    1. dAngle `[degree]` : Rotational range of X-ray source 
    2. nView `[unit]` : The number of views 
    3. dView `[degree]` : The step of views
    4. DSO `[mm]` : Distance from Source to Object
    5. DSD `[mm]` : Distance from Source to Detector 

* X-ray detector parameters
    1. dDctX `[mm]` : Detector pitch
    2. nDctX `[unit]` : The number of detectors
    3. dOffsetDctX `[float]` : Index of shifted detectors (+, -)
    4. compute_filtering `[convolution, fft]` : Filtering method
    
* Object parameters 
    1. dImgX, dImgY `[mm]` : Pixel resolution
    2. nImgX, nImgY `[unit]` : The number of pixels
    3. dOffsetImgX, dOffsetImgY `[float]` : Index of shifted image (+, -)


## Results
![alt text](./img/reconstruction_image.png "Reconstructed image using parallelbeam")
* The results were reconstructed by below hyper parameters.

* X-ray CT System parameters
    1. dAngle `[degree]` : 360 
    2. nView `[unit]` : 360 
    3. dView `[degree]` : 1
    4. DSO `[mm]` : 400
    5. DSD `[mm]` : 800 

* X-ray detector parameters
    1. dDctX `[mm]` : 0.7
    2. nDctX `[unit]` : 400
    3. dOffsetDctX `[float]` : 30
    4. compute_filtering `[convolution, fft]` : 'fft'
    
* Object parameters 
    1. dImgX, dImgY `[mm]` : 1, 1
    2. nImgX, nImgY `[unit]` : 256, 256
    3. dOffsetImgX, dOffsetImgY `[float]` : 0, 0
