#include<stdio.h>
#include"common.h"
#include <cstring>
#include <iostream>
#include <fstream>
#include <cmath> 
enum raw_fmt_e {FMT_R,FMT_Gr,FMT_Gb,FMT_B};

int main(){

    int datPic     [256][256]                      = {0};  // 256 * 256
    int datPic_R   [256][256]                      = {0};  // 256 * 256
    int datPic_G   [256][256]                      = {0};  // 256 * 256
    int datPic_B   [256][256]                      = {0};  // 256 * 256
    int diffA;
    int diffB;
    int gdataA;
    int gdataB;

    float pic_data1;
    float pic_data2;
   
    char* raw_fmt[4] = {"FMT_R","FMT_Gr","FMT_Gb","FMT_B"};

    int fmt_revert = 0;
    int index = 0;
    
    FILE* file_;
    char rdata[80] = "";
    int used = 0;
    int offset = 0;
    int rdata1;
    int m0=0;
    int n0=0;
    
    char result[5] = "";

    raw_fmt_e    data_fmt[256][256];

    ofstream ofs;
    file_ = fopen("isp_input.txt","r");

    while(fgets(rdata,sizeof(rdata),file_)) {
       // printf("%s \n",rdata);
        used = 0;
        offset = 0;
        while((sscanf(rdata+used,"0x%x %n",&rdata1,&offset))==1) {
         //   printf(" 0x%x ",rdata1);
            used = used+offset;
            datPic[m0][n0] = rdata1;
            if(n0<255)
                n0=n0+1;
            else {
                m0=m0+1;
                n0=0;
            }
            //printf("m = %d n= %d \n",m0,n0);
        }
//        printf("m = %d n= %d \n",m0,n0);
    }
    fclose(file_);

//    ifstream file("dma_test.txt");
 



    //Read picture
    for(int j = 0; j < 256; j++){
        for (int i=0;i<256;i++)  {
//            file >> datPic[j][i];
            if(fmt_revert ==0) {
               if(i%2==0)
                 data_fmt[j][i] = FMT_B ;
               else
                 data_fmt[j][i] = FMT_Gb ;
            } else {
               if(i%2==0)
                 data_fmt[j][i] = FMT_Gr ;
               else
                 data_fmt[j][i] = FMT_R ;
            }
        }

        if(fmt_revert == 0)
           fmt_revert = 1;
        else
           fmt_revert = 0;
    }

// cal g
    for(int j = 0; j < 256; j++){
        for (int i=0;i<256;i++)  {
            switch(data_fmt[j][i])
            {
                case FMT_B :
                    if((i>0)&&(j>0)) {
                        pic_data1 = (float) datPic[j][i-1];
                        pic_data2 = (float) datPic[j][i+1];
                        diffA = (int) abs(pic_data1 - pic_data2) ;
                        pic_data1 = (float) datPic[j-1][i];
                        pic_data2 = (float) datPic[j+1][i];
                        diffB = (int) abs(pic_data1 - pic_data2) ;
                        gdataA = (datPic[j][i-1] + datPic[j][i+1])/2 ; 
                        gdataB = (datPic[j-1][i] + datPic[j+1][i])/2 ; 
                        datPic_G[j][i] = (diffA<diffB) ? gdataA:((diffA==diffB)? (gdataA+gdataB)/2 : gdataB ) ;
                  //      printf("kgay21062 debug datPic_G[%d][%d] %d \n",j,i,datPic_G[j][i]);
                    };
                    break;
                case FMT_Gb:
                    datPic_G[j][i] = datPic[j][i] ;
                 //   printf("datPic_G[%d][%d] %d \n",j,i,datPic_G[j][i]);
                    break;
                case FMT_Gr:
                    datPic_G[j][i] = datPic[j][i] ;
                 //   printf("datPic_G[%d][%d] %d \n",j,i,datPic_G[j][i]);
                    break;
                case FMT_R :
                    if((i>0)&&(j>0)) {
                        pic_data1 = (float) datPic[j][i-1];
                        pic_data2 = (float) datPic[j][i+1];
                        diffA = (int) abs(pic_data1 - pic_data2) ;
                        pic_data1 = (float) datPic[j-1][i];
                        pic_data2 = (float) datPic[j+1][i];
                        diffB = (int) abs(pic_data1 - pic_data2) ;
                        gdataA = (datPic[j][i-1] + datPic[j][i+1])/2 ; 
                        gdataB = (datPic[j-1][i] + datPic[j+1][i])/2 ; 
                        datPic_G[j][i] = (diffA<diffB) ? gdataA:((diffA==diffB)? (gdataA+gdataB)/2 : gdataB );
              //          printf("datPic_G[%d][%d] %d \n",j,i,datPic_G[j][i]);
                    };
                    break;
                default:
                    break;
            }
        }
    }


// cal b

    for(int j = 0; j < 256; j++){
        for (int i=0;i<256;i++)  {
            switch(data_fmt[j][i])
            {
                case FMT_B :
                    datPic_B[j][i] = datPic[j][i] ;
                    break;
                case FMT_Gb:
                    if(i>0&&j>0) {
                        datPic_B[j][i] = datPic_G[j][i]+(datPic[j][i-1]+datPic[j][i+1])/2-(datPic_G[j][i-1]+datPic_G[j][i+1])/2;
                    };
                    break;
                case FMT_Gr:
                    if(i>0&&j>0) {
                        datPic_B[j][i] = datPic_G[j][i]+(datPic[j-1][i]+datPic[j+1][i])/2-(datPic_G[j-1][i]+datPic_G[j+1][i])/2;
                    };
                    break;
                case FMT_R :
                   if(i>0&&j>0) {
                        datPic_B[j][i] = datPic_G[j][i]+(datPic[j-1][i-1]+datPic[j+1][i-1]+datPic[j+1][i+1]+datPic[j-1][i+1])/4-(datPic_G[j-1][i-1]+datPic_G[j+1][i-1]+datPic_G[j+1][i+1]+datPic_G[j-1][i+1])/4;
                    };
                   break;
                default:
                   break;
            }
        }
    }

// cal r    

    for(int j = 0; j < 256; j++){
        for (int i=0;i<256;i++)  {
            switch(data_fmt[j][i])
            {
                case FMT_B :
                    if(i>0&&j>0) {
                       datPic_R[j][i] =  datPic_G[j][i]+(datPic[j-1][i-1]+datPic[j+1][i-1]+datPic[j+1][i+1]+datPic[j-1][i+1])/4-(datPic_G[j-1][i-1]+datPic_G[j+1][i-1]+datPic_G[j+1][i+1]+datPic_G[j-1][i+1])/4 ;
                    };
                    break;
                case FMT_Gr:
                    if(i>0&&j>0) {
                       datPic_R[j][i] = datPic_G[j][i]+(datPic[j][i-1]+datPic[j][i+1])/2-(datPic_G[j][i-1]+datPic_G[j][i+1])/2;
                    };
                    break;
                case FMT_Gb:
                    if(i>0&&j>0) {
                       datPic_R[j][i] = datPic_G[j][i]+(datPic[j-1][i]+datPic[j+1][i])/2-(datPic_G[j-1][i]+datPic_G[j+1][i])/2;
                    };
                    break;
                case FMT_R :
                    datPic_R[j][i] = datPic[j][i] ;
                default:
                    break;
            }
        }
    }

     
    ofs.open("result_b.txt",ios::out);

    for(int j=0;j<256;j++) {
        for(int i=0;i<256;i++) {
            if(datPic_R[j][i]<0) {
               printf("result %s  datPic_R[%0d][%0d] %x \n",result,j,i,datPic_R[j][i]);
               datPic_R[j][i] = 0;
            }
            sprintf(result,"0x%02x ",datPic_R[j][i]);

            ofs << result ;
            if(i%16==15)
                ofs << endl;
        }
    }
    ofs.close();


    ofs.open("result_g.txt",ios::out);
    for(int j=0;j<256;j++) {
        for(int i=0;i<256;i++) {
            if(datPic_G[j][i]<0) {
               printf("result %s  datPic_G[%0d][%0d] %x \n",result,j,i,datPic_G[j][i]);
               datPic_G[j][i] = 0;
            }
            sprintf(result,"0x%02x ",datPic_G[j][i]);

            ofs << result ;
            if(i%16==15)
                ofs << endl;
        }
    }
    ofs.close();

    ofs.open("result_r.txt",ios::out);
    for(int j=0;j<256;j++) {
        for(int i=0;i<256;i++) {
            if(datPic_B[j][i]<0) {
               printf("result %s  datPic_B[%0d][%0d] %x \n",result,j,i,datPic_B[j][i]);
               datPic_B[j][i] = 0;
            }
            sprintf(result,"0x%02x ",datPic_B[j][i]);

            ofs << result ;
            if(i%16==15)
                ofs << endl;
        }
    }
    ofs.close();

    printf("DATA: \n");
    for(int j = 0; j < 10; j++){
        for(int i =0;i<10;i++) {
           index = data_fmt[j][i];
           printf(" %3x ",datPic[j][i]);
        }
        printf("\n ");
    }
    printf("FMT: \n");
    for(int j = 0; j < 10; j++){
        for(int i =0;i<10;i++) {
           index = data_fmt[j][i];
           printf(" %s ",raw_fmt[index]);
        }
        printf("\n ");
    }
   printf("R: \n");
    for(int j = 0; j < 10; j++){
        for(int i =0;i<10;i++) {
           index = data_fmt[j][i];
           printf(" %3x  ",datPic_R[j][i]);
        }
        printf("\n ");
    }
   printf("G:\n ");
    for(int j = 0; j < 10; j++){
        for(int i =0;i<10;i++) {
           index = data_fmt[j][i];
           printf(" %3x  ",datPic_G[j][i]);
        }
        printf("\n ");
    }
   printf("B:\n ");
    for(int j = 0; j < 10; j++){
        for(int i =0;i<10;i++) {
           index = data_fmt[j][i];
           printf(" %3x  ",datPic_B[j][i]);
        }
        printf("\n ");
    }

    return 0;
}
