#include<bits/stdc++.h>
using namespace std;
int main(){
    int n;
    cin>>n;
    double cur=1;
    double sum=0;
    for(int i=0;i<10;i++){
        int left=0,right=10;
        double tmp=0;
        while(right-left>1){
            int mid=(right+left)/2;
            tmp=sum+mid*cur;
            if(tmp*tmp<=n){
                left=mid;
            } else {
                right=mid;
            }
        }
        sum=sum+left*cur;
        cur*=0.1;
    }
    printf("%.10lf\n", sum);
    return 0;
}
