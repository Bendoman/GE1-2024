![image](https://github.com/user-attachments/assets/23327c32-88ec-43c6-99c7-c44c9e59e056)# Work undertaken for week 8

Created empire state building gravity example from class <br>
![image](https://github.com/user-attachments/assets/ee2ee8ad-27b5-4ff2-a0ca-08116b115fb3)

The custom physics node falls at the correct rate. But the rigid body falls more slowly <br>
![image](https://github.com/user-attachments/assets/fb8cef98-24da-4339-85b1-b42c936b9745)

This deviation from correct physics appears to be because godot applies a linear damp to falling objects. <br>
![image](https://github.com/user-attachments/assets/4e4490e6-a6c6-4cb6-96d2-efdfeef5d24f)

Setting this to 0 resolves the majority of the disparity. The custom physics node is still very slightly more accurate as shown below. <br>
![image](https://github.com/user-attachments/assets/37f43091-3b17-4087-81cf-77037a7ec319)

