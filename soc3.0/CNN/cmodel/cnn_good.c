//#include "svdpi.h"
//#include "svdpi_src.h"
#include <stdio.h>

#define IMG_SIZE 32
#define W_SIZE   3
#define W_NUM   2
#define OUT_CONV_SIZE 30

#define IMG_CH   3
#define OUT_CH 2 

#define IMG_POOL_SIZE 30
#define IMG_POOL_NUM 2
#define OUT_POOL_SIZE 15 

#define SOLICE_SIZE 15

#define LINE_SIZE 15
#define OUT_LINE (LINE_SIZE*LINE_SIZE*LINE_CH)

#define OUT_SIZE 450

// cnn_data.size() == 1024;
// cnn_conv_out.size() == 1800;
// cnn_pool_out.size() == 450;
// cnn_line_out.size() == 2;
// cnn_kernel0.size() == 9;
// cnn_kernel1.size() == 9;
// lines0.size() == 450;
// lines1.size() == 450;


int i,j,k,r,m,n,num;

int datPic       [32][32] = {0};
int datPic_conv0 [30][30] = {0};
int datPic_conv1 [30][30] = {0};
int datPic_pool  [30][15] = {0};
int datPic_pool1 [15][15] = {0};
int datPic_pool2 [15][15] = {0};
int datPic_line  [450]    = {0};

int cnn(int cnn_data[1024],int cnn_kernel0[9],int cnn_kernel1[9], int c_out0[900],int c_out1[900],int pool_out[450] ,int line_out[450] ){


    int conv_w0[W_SIZE][W_SIZE] = {1,0,0,  0,0,0,  0,0,0};
    int conv_w1[W_SIZE][W_SIZE] = {1,0,1,  0,1,0,  1,0,1};
    int output_conv[OUT_CONV_SIZE][OUT_CONV_SIZE] = {0};
    int conv_out_tmp;
   
    printf("CNN Start !");


    for(i = 0;i < 32;i++){
    	for(j = 0;j < 32;j++){
	        datPic[i][j] = cnn_data[k];
		    k++;
	    }
    }
    
    k = 0;

    for(i = 0;i < 3;i++){
    	for(j = 0;j < 3;j++){
	        conv_w0[i][j] = cnn_kernel0[k];
		    k++;
	    }
    }

    k = 0;

    for(i = 0;i < 3;i++){
    	for(j = 0;j < 3;j++){
	        conv_w1[i][j] = cnn_kernel1[k];
            c_out1[k] = cnn_kernel1[k];
		    k++;
	    }
    }

//单通道单卷积1 conv function
    int tmp=0;
    k = 0;

    for(k=0;k < IMG_SIZE - W_SIZE + 1;k++)  //特征平面的行  列平移 行卷积
    {

        for(r=0;r < IMG_SIZE - W_SIZE + 1;r++) //特征平面的列  行平移  列卷积
        {
            tmp = 0;
            //单次卷积 点对点相乘 然后相加
            for(i=0;i<W_SIZE;i++) //卷积的行
            {
                for(j=0;j<W_SIZE;j++) //卷积的列
                {
                    tmp       +=  datPic[i+k][j+r]*conv_w0[i][j];
                }
            }
            conv_out_tmp =  tmp > 0 ? tmp : 0;//Rule active function

            datPic_conv0[k][r] = conv_out_tmp & 0xff;//Rule active function
        }

    }

    k = 0;

    printf("Print cout !");

    for(i = 0;i < 30;i++){
    	for(j = 0;j < 30;j++){
            c_out0[k] = datPic_conv0[i][j];
            printf("0x%d ",c_out0[k]);
    	    k++;
        }
    }


//单通道单卷积2 conv function

    k = 0;

    for(k=0;k < IMG_SIZE - W_SIZE + 1;k++)  //特征平面的行  列平移 行卷积
    {

        for(r=0;r < IMG_SIZE - W_SIZE + 1;r++) //特征平面的列  行平移  列卷积
        {
            tmp = 0;
            //单次卷积 点对点相乘 然后相加
            for(i=0;i<W_SIZE;i++) //卷积的行
            {
                for(j=0;j<W_SIZE;j++) //卷积的列
                {
                    tmp +=  datPic[i+k][j+r]*conv_w1[i][j];
                }
            }

            conv_out_tmp = tmp > 0 ? tmp : 0;//Rule active function
            datPic_conv1[k][r] = conv_out_tmp&0xff;//Rule active function

        }
    }

    k = 0;

    for(i = 0;i < 30;i++){
    	for(j = 0;j < 30;j++){
            c_out1[k] = datPic_conv1[i][j];
		    k++;
	    }
    }

   
    //max_pooling
    int img_pool[IMG_POOL_SIZE][IMG_POOL_SIZE] = {0};
   
    printf("After max pool\n");



//单通道最大池化1 max_pooling function


    int tmp1,tmp2,tmp3;
    for(i=0,k=0;i<IMG_POOL_SIZE,k<OUT_POOL_SIZE;i=i+2,k++)
    {
         
        for(j=0,r=0;j<IMG_POOL_SIZE,r<OUT_POOL_SIZE;j=j+2,r++)
        {
           
            tmp1 = 0;
            tmp2 = 0;
            tmp3 = 0;
            tmp1 = datPic_conv0[i][j] > datPic_conv0[i][j+1] ? datPic_conv0[i][j]:datPic_conv0[i][j+1];
            tmp2 = datPic_conv0[i+1][j] > datPic_conv0[i+1][j+1] ? datPic_conv0[i+1][j] : datPic_conv0[i+1][j+1];
            tmp3 = tmp1 > tmp2 ? tmp1:tmp2;
            datPic_pool1[k][r] = tmp3;
        } 
         
    }
          printf("\n");  

//单通道最大池化2 max_pooling function


    k = 0;

    //int tmp1,tmp2,tmp3;
    for(i=0,k=0;i<IMG_POOL_SIZE,k<OUT_POOL_SIZE;i=i+2,k++)
    {
         
        for(j=0,r=0;j<IMG_POOL_SIZE,r<OUT_POOL_SIZE;j=j+2,r++)
        {
           
            tmp1 = 0;
            tmp2 = 0;
            tmp3 = 0;
            tmp1 = datPic_conv1[i][j] > datPic_conv1[i][j+1] ? datPic_conv1[i][j]:datPic_conv1[i][j+1];
            tmp2 = datPic_conv1[i+1][j] > datPic_conv1[i+1][j+1] ? datPic_conv1[i+1][j] : datPic_conv1[i+1][j+1];
            tmp3 = tmp1 > tmp2 ? tmp1:tmp2;
            datPic_pool2[k][r] = tmp3;
        } 
         
    }



//arry solic


    for(i = 0;i < 15;i++){
    	for(j = 0;j < 15;j++){
	    datPic_pool[i][j] = datPic_pool1[i][j];
	}
    }

	printf("\n");
    
    for(i = 0;i < 15;i++){
    	for(j = 0;j < 15;j++){
	        datPic_pool[15+i][j] = datPic_pool2[i][j];
	    }    
    }

    //line
    int line_temp[15][LINE_SIZE] = {0};
    int out_line[450] = {0};

    //convert(datPic_pool,datPic_line);//cal line

     for(i=0;i<30;i++) {
         for(j=0;j<15;j++) {
             datPic_line[j+i*15] = datPic_pool[i][j];
         }
     }

    for(i=0;i<450;i++) {
        pool_out[i] = datPic_line[i];
    }

    //全连接层求和sum
    int sum1 = 0;
    int sum2 = 0;
    for(j = 0;j < 450;j++){
    	sum1 = 8 * datPic_line[j];
    }

    for(j = 0;j < 450;j++){
    	sum2 = 120 * datPic_line[j];
    }


    //result
    int result = 0;
    if(sum1 < sum2)
	    result = 1;
    else
	    result = 0;

    //
    printf("UVM DPI-C import successful!");


    return result;
}

/*int main()
{

    int cnn_data[1024]    = {0};
    int cnn_kernel0[9]    = {0};
    int cnn_kernel1[9]    = {0};
    int c_out0[900]       = {0};
    int c_out1[900]       = {0};
    int line_out[450]     = {0};
    int result ;
    int i;

    for(i=0;i<1024;i++) {
        cnn_data[i] = i;
    }

    for(i=0;i<9;i++) {
        cnn_kernel0[i] = i;
    }

    for(i=0;i<9;i++) {
        cnn_kernel0[i] = i;
    }

    result = cnn(cnn_data,cnn_kernel0,cnn_kernel1, c_out0,c_out1,line_out);

    printf("Check result ");

    for(i=0;i<900;i++) {
        printf("0x%d ",c_out0[k]);
    }

}
*/
