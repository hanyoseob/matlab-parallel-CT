# Parallelbeam CT

### Reference 
[Computed Tomography: Principles, Design, Artifacts, and Recent Advances, 3rd.](http://bitly.kr/SOw7Yb1s)

> The beginners, who is unfamiliar about the CT concept and principle, read Chapter 3. Image Reconstruction.

### Abstract
X-ray computed tomography (CT) has experienced an explosion of technological development for a quarter century. Six years after the second edition of Computed Tomography, this third edition captures the most recent advances in technology and clinical applications. New to this edition are descriptions of iterative reconstruction, statistical reconstruction, methodologies used to model the CT systems, and the searching methodologies for optimal solutions. A new section on 3D printing introduces approaches by early adopters in the area. Also added is a description and discussion of the size-specific dose estimate, an index that attempts to more accurately reflect the dose absorption of specific-sized patients. The coverage of dual-energy CT has been significantly expanded to include its background, theoretical development, and clinical applications.
      
## Projection
* Projection operator is implemented based on Ch.3 Equations (3.5) & (3.6).
* `Ray-driven method` is applied to Projection operator.

    * Ch.3 Equation (3.5): `Rotated coordinate` X-ray CT system (`Counterclockwise`).
        * ![eq-t-axis](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20t%20%3D%20x%20%5Ccos%28%5Ctheta%29%20&plus;%20y%20%5Csin%28%5Ctheta%29)
        * ![eq-s-axis](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20s%20%3D%20-x%20%5Csin%28%5Ctheta%29%20&plus;%20y%20%5Ccos%28%5Ctheta%29)

    * Ch.3 Equation (3.6): `Line integration` along X-ray.
        * ![eq-line-integration](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20p%28t%2C%5Ctheta%29%20%3D%20%5Cint_%7B-%5Cinfty%7D%5E%7B&plus;%5Cinfty%7Df%27%28t%2Cs%29%20ds)

## Filtering
* Filtering operator is implemented based on Ch.3 Equations (3.21) & (3.29) & (3.30).

    * Ch.3 Equation (3.29): `Filtering kernel`
        * ![eq-filtering-kernel](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20h%28n%5Cdelta%29%20%3D%20%5Cleft%5C%7B%5Cbegin%7Bmatrix%7D%20%5Cfrac%7B1%7D%7B4%5Cdelta%5E2%7D%2C%20%26%20n%3D0%2C%7E%7E%7E%5C%5C%200%2C%20%26%20n%3Deven%2C%5C%5C%20-%20%5Cfrac%7B1%7D%7B%28n%5Cpi%5Cdelta%29%5E2%7D%20%2C%20%26%20n%3Dodd.%7E%20%5Cend%7Bmatrix%7D%5Cright.)
        
* Filtering is performed by `convolution ver.` using Ch.3 Equation (3.30) and `FFT ver.` using Equation (3.21).
    * Ch.3 Equation (3.30): `convolution ver.` 
        * ![eq-convolution](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20f%28x%2Cy%29%3D%5Cint_%7B0%7D%5E%7B%5Cpi%7Dd%5Ctheta%5Cint_%7B-t_%7Bm%7D%7D%5E%7B&plus;t_%7Bm%7D%7D%7Bp%28t%27%2C%20%5Ctheta%29h%28t-t%27%29dt%27%7D)
    * Ch.3 Equation (3.21): `FFT ver.`
        * ![eq-FFT](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20g%28t%2C%5Ctheta%29%20%3D%20g%28x%20%5Ccos%28%5Ctheta%29%20&plus;%20y%20%5Csin%28%5Ctheta%29%29%20%5C%5C%5C%5C%20%7E%7E%7E%7E%7E%7E%7E%7E%7E%7E%7E%7E%7E%3D%20%5Cint_%7B-%5Cinfty%7D%5E%7B&plus;%5Cinfty%7DP%28%5Comega%2C%5Ctheta%29%7C%5Comega%7C%20e%5E%7Bj2%5Cpi%5Comega%28x%5Ccos%28%5Ctheta%29%20&plus;%20y%20%5Csin%28%5Ctheta%29%29%7D%20d%5Comega)

## Backprojection
* Backprojection operator is implemented based on Ch.3 Equation (3.22).
* `Pixel-driven method` is applied to backprojection operator.

    * Ch.3 Equation (3.22): `Backprojection`
        * ![eq-backprojection](http://latex.codecogs.com/gif.latex?%5Cdpi%7B150%7D%20%5Cbg_white%20%5Cfn_cm%20%5Clarge%20f%28x%2C%20y%29%20%3D%5Cint_%7B0%7D%5E%7B%5Cpi%7Dg%28x%20%5Ccos%28%5Ctheta%29%20&plus;%20y%5Csin%28%5Ctheta%29%29d%5Ctheta)
        
## Parameters
* X-ray CT System parameters
    1. dAngle `[degree; (float, +)]` : Rotational range of X-ray source 
    2. nView `[element; (int, +)]` : The number of views 
    3. dView `[degree; (float, +)]` : The step of view
    4. DSO `[mm; (float, +)]` : Distance from Source to Object
    5. DSD `[mm; (float, +)]` : Distance from Source to Detector 

* X-ray detector parameters
    1. dDctX `[mm; (float, +)]` : Detector pitch
    2. nDctX `[element; (int, +)]` : The number of detectors
    3. dOffsetDctX `[float; (float, +-)]` : Index of shifted detectors
    4. compute_filtering `['convolution', 'fft'; (string)]` : Filtering method
    
* Object parameters 
    1. dImgX, dImgY `[mm; (float, +)]` : Pixel resolutions
    2. nImgX, nImgY `[element; (int, +)]` : The number of pixels
    3. dOffsetImgX, dOffsetImgY `[element; (float, +-)]` : Index of shifted image


## Results
![alt text](./img/reconstruction_image.png "Reconstructed image using parallel beam CT")
* The results were reconstructed by hyper parameters below.

* X-ray CT System parameters
    1. dAngle `[degree; (float, +)]` : 360 
    2. nView `[element; (int, +)]` : 360 
    3. dView `[degree; (float, +)]` : 1
    4. DSO `[mm; (float, +)]` : 400
    5. DSD `[mm; (float, +)]` : 800 

* X-ray detector parameters
    1. dDctX `[mm; (float, +)]` : 0.7
    2. nDctX `[element; (int, +)]` : 400
    3. dOffsetDctX `[element; (int, +-)]` : 30
    4. compute_filtering `['convolution', 'fft'; (string)]` : 'fft'
    
* Object parameters 
    1. dImgX, dImgY `[mm; (float, +)]` : 1, 1
    2. nImgX, nImgY `[element; (int, +)]` : 256, 256
    3. dOffsetImgX, dOffsetImgY `[element; (float, +-)]` : 0, 0

## Execution Time
* While Matlab is optimized to calculate the Matrix operation, it is calculated by pixel operation to match the Equations explicitly. 
* Therefore, the execution time is slow as shown in a table below.

| Operation  | Execution time | Remark |
| :---------:| :------------: | :----: |
| Projection | about 1000 sec | *ray-driven* |
| (a) Filtering | about 0.025 sec | *convolution* |
| (b) Filtering | about 0.050 sec | *zero-padding + FFT*|
| Backprojection | about 300 sec | *pixel-driven* |

> To reduce the execution time, Codes of `C/C++ ver.` and/or `Python ver.` code will be published **as soon as possible**.