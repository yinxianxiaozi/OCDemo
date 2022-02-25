//
//  main.m
//  algorithmTest
//
//  Created by 张文艺 on 2021/9/6.
//

#import <Foundation/Foundation.h>


/*
 选择排序
 堆排序
 */
//选择排序
/*
 1、循环给所有的元素进行排序
 2、得到无序区中的最小值
 3、与本趟待排序元素进行交换
 */
//注意点：定义一个临时下标值作为查找出的最小值的下标
void selectSort(NSMutableArray *arr,int n){
    int i,j,k;//k作为最小元素的临时下标值
    NSString *tmp;
    //对第几个数进行排序
    for (i=0; i<n-1; i++) {
        k = i;//将当前需要比较的数元素下标拿出来
        //对无序区进行比较
        for (j = i+1; j<n; j++) {
            //如果
            if ([arr[j] intValue] < [arr[k] intValue]) {
                k = j;
            }
        }
        //将当前的i的值与无序区中取出的最小元素进行交换
        if (k!=i) {
            tmp = arr[i];
            arr[i] = arr[k];
            arr[k] = tmp;
        }
    }
    NSLog(@"selectSort:%@",arr);
}

//堆排序
/*
 通过筛选算法构建堆
 1、左右孩子节点比较较大者
 2、左右孩子节点的较大者与双亲节点比较较大者
 3、如果双亲节点较大，就不做处理，如果孩子节点较大，
 
 因为当前的双亲节点+左右孩子节点的基本结构修改后，可能会破坏下一级的堆，所以需要不断的向下筛选，一直到high
 */
//low表示需要筛选的点，high表示需要筛选的节点数量
void sift(NSMutableArray *arr,int low,int high){
    int i = low,j = 2 * i;//arr[j]是arr[i]的左孩子，arr[j+1]是arr[i]的右孩子
    NSString *tmp = arr[i];
    //high表示最大的节点位置
    while (j <= high) {
        //左右孩子节点比较较大者
        if (j < high && [arr[j] intValue] < [arr[j+1] intValue]) {//若左孩子<右孩子，把j指向右孩子
            j++;
        }
        //左右孩子节点的较大者与双亲节点比较
        /*
         做了两件事
         1)交换双亲结点与左(右)节点位置
         2)修改i和j值，以便继续向下筛选
         */
        if ([tmp intValue] < [arr[j] intValue]) {
            //将arr[j]调整到双亲节点位置上
            arr[i] = arr[j];
            //修改i和j值，以便继续向下筛选
            i = j;
            j = 2 * i;
        } else {
            break;//筛选结束
        }
    }
    //也就是找到了最终的位置，此时把它放进去
    arr[i] = tmp;//被筛选节点的值放入最终位置
}

/*
 1、创建初始堆
 2、堆顶最大值与最后一个元素交换
 3、筛选剩下的节点
 */
void HeapSort(NSMutableArray *arr,int n){
    int i;
    NSString *tmp;
    //循环建立初始堆
    /*
     i表示根节点，i取值范围为1~n/2，1很好理解，就是第一个根节点，n/2是因为完全二叉树的特性，根节点总数为n/2
     所以这里就是取出每个根节点，并且循环进行构造。
     
     最基本的构造：双亲结点与左右孩子节点进行比较，较大者作为双亲节点
     循环最基本的构造来实现所有的节点的比较。
     */
    for (i = n/2; i >= 1; i--) {
        sift(arr,i,n);
    }
    
    /*
     1、每趟获取到最后一个节点，为什么是i>=2呢，这是因为当只有一个元素时不需要比较了，所以比较的是n-1趟，也就是[n,2]
     2、将当前根节点与第一个元素进行交换
     3、再次构建堆
     */
    
    for (i = n; i >= 2; i--) {//进行n-1趟堆排序，每一趟堆排序的元素个数减1
        tmp = arr[1];//将最后一个元素同当前区间内arr[1]对换
        arr[1] = arr[i];
        arr[i] = tmp;
        sift(arr, 1, i-1);//筛选arr[1]节点，得到i-1个节点的堆
    }
    NSLog(@"HeapSort:%@",arr);
}


/*
 插入
 折半插入
 希尔
 */
//插入排序
/*
 1、第一轮，拿到无序区的第一个数据
 2、第二轮：在有序区中从后往前比较，将所有大于tmp的元素都向后挪，一直到不大于的时候就将tmp放入当前位置
 */
/*
 这里需要注意的是：
 并不是先一个个比较得到所在位置，再去移动该位置之后的其他数据
 而是直接从后往前比较每一个数据，只要大于的就往后移动
 */
void insertSort(NSMutableArray *arr,int n){
    int i,j;
    for (i=1; i<n; i++) {//遍历无序区，所以从下标1开始
        NSString *tmp = arr[i];
        j=i-1;//先拿到有序区的最后一个，j最大值是无序区的前一个
        //不断遍历，将所有大于tmp的值都挪到后面
        while (j>0 && [tmp intValue] < [arr[j] intValue]) {
            arr[j+1] = arr[j];
            j--;
        }
        //插入到当前位置
        arr[j+1] =tmp;
    }
    NSLog(@"insertSort:%@",arr);
}

//折半插入
void binaryInsertSort(NSMutableArray *arr,int n){
    int i,j,low,high,mid;
    NSString *tmp;
    for (i=1; i<n; i++) {
        tmp = arr[i];
        low = 0;
        high = i-1;
        while (low<=high) {
            mid = (low +high)/2;
            if ([tmp intValue] <[arr[i] intValue]) {
                high = mid -1;
            } else {
                low = mid +1;
            }
        }
        //整体向后移动
        for (j=i-1; j>=high+1; j--) {
            arr[j+1] = arr[j];
        }
        arr[high+1] = tmp;
    }
    NSLog(@"binaryInsertSort:%@",arr);
}

//希尔排序
/*
 1、获取到初始增量
 2、直接插入排序
 3、缩小增量
 */
/*
 1、增量的意思是在从当前位置计算下一个位置需要增加的量，也就是待排序的元素的间隔。
 2、在直接插入排序中，元素间隔为1（不按照0来算，因为我所指的间隔是从这个元素跳到下一个元素需要+1）
 3、在希尔排序中，元素间隔为一个增量，也就是从这个元素跳到下一个元素需要+gap
 */
void ShellSort(NSMutableArray *arr,int n){
    int i,j,gap;
    NSString *tmp;
    gap = n/2;//初始增量
    while (gap > 0) {//不断缩小增量，直到增量为1，此时1/2 = 0，便不再进入.增量为1就和普通的直接插入排序一样了
        //对每组都进行直接插入排序，相距的间隔为gap，其他的都一样
        for (i = gap; i<n; i++) {
            tmp = arr[i];
            j = i-gap;
            while (j >= 0 && [tmp intValue] < [arr[j] intValue]) {
                arr[j+gap] = arr[j];
                j = j-gap;
            }
            arr[j+gap] = tmp;
        }
        //缩小增量
        gap = gap/2;
    }
    NSLog(@"binaryInsertSort:%@",arr);
}


/*
 冒泡
 堆排序
 */
//冒泡排序
/*
 1、第一个for循环依次取出所有的元素
 2、第二个for循环依次取出当前所选元素的后边元素并进行比较大小
 3、较大的放在后边，较小的放在前边
 */
void BubbleSort(NSMutableArray *arr,int n){
    int i,j;
    NSString *tmp;
    for (i=0;i<n-1; i++) {//一趟遍历就是一个元素的归位
        for (j=n-1; j>i; j--) {//采用从顶到底的比较，比较出最小的元素
            if ([arr[j] intValue] < [arr[j-1] intValue]) {//如果后边的元素较小，就进行交换
                tmp = arr[j];
                arr[j] = arr[j-1];
                arr[j-1] = tmp;
            }
        }
    }
    
    NSLog(@"BubbleSort:%@",arr);
}

/*
 可以看做是下边的元素不断往上走，元素越来越大，最后最大的元素放到顶端，就像是水里的泡泡往上冒一样，随着水压的减小，越往上泡泡越大，这就是所谓的冒泡
 1、第一个for循环依次取出所有的元素
 2、第二个for循环依次取出当前所选元素的后边元素并进行比较大小
 3、较大的放在后边，较小的放在前边
 */
void BubbleSort1(NSMutableArray *arr,int n){
    int i,j;
    NSString *tmp;
    for (i=0;i<n-1; i++) {//一趟遍历就是一个元素的归位
        for (j = 0; j<n-i-1; j++) {//每次将最后一个元素归位，所以这里是j<n-i-1,而不是j<n-1
            if ([arr[j] intValue] > [arr[j+1] intValue]) {//如果下边的元素较大，就进行交换，往上冒一下
                tmp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = tmp;
            }
        }
    }
    
    NSLog(@"BubbleSort1:%@",arr);
}


//优化后的冒泡排序
/*
 在原来的基础上增加一个bool判断，如果这一趟比较没有一次交换，就说明已经排好序了，就直接停止排序
 */
void bubbleSort_better(NSMutableArray *arr,int n){
    int i,j;
    bool exchange;
    NSString *tmp;
    for (i = 0; i<n-1; i++) {
        exchange = false;
        for (j = 0; j<n-i-1; j++) {//每次将最后一个元素归位，所以这里是j<n-i-1,而不是j<n-1
            if ([arr[j] intValue] > [arr[j+1] intValue]) {//如果下边的元素较大，就进行交换，往上冒一下
                tmp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = tmp;
                exchange = true;
            }
        }
        if (!exchange) {
            NSLog(@"bubbleSort_better:%@",arr);
            return;
        }
    }
    
}

/*
 前面的排序方法，上一次排序次数-1作为下一轮排序的次数，但是如果在数组未排序部分已经局部序列，这些序列无序再次排序。
 因此还有一种优化策略，记录上一轮最后一次交互的位置，把这个位置作为下一轮的排序次数。
 */
void bubbleSort_better2(NSMutableArray *arr,int n){
    int i,j;
    NSString *tmp;
    int end = n-1;
    for (i=0;i<n-1; i++) {//一趟遍历就是一个元素的归位
        int lastSwapIndex = 1;
        for (j = 0; j<end-i; j++) {//每次将最后一个元素归位，所以这里是j<n-i-1,而不是j<n-1
            if ([arr[j] intValue] > [arr[j+1] intValue]) {//如果下边的元素较大，就进行交换，往上冒一下
                tmp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = tmp;
                lastSwapIndex = j;//记录交互位置
            }
        }
        //将最后一次交互位置作为下一轮的排序最大位置。
        end = lastSwapIndex;
    }
    
    NSLog(@"BubbleSort1:%@",arr);
}

//快速排序
/*
 1、以第一个元素作为基准tmp
 2、从右到左扫描，找到小于tmp的值，放到左区间的空位置（第一次的空位置是第一个位置，这是没问题的，因为已经赋给tmp了）
 3、从左到右扫描，找到大于tmp的值，放到右区间的空位置（此时右区间肯定会有空位置，否则i=j了，就不会执行从左到右扫描了）
 */
/*
 实现细节：
    1、一次只能将一个元素归位，采用递归可以将所有的元素归位
    2、一个元素的归位需要将当前区间的所有元素都进行比较，从右到左和从左到右交替扫描，一直到i=j
    3、如果在右区间进行交换，直接将左区间的第一个元素进行覆盖，这是没问题的，因为已经赋给tmp了
    4、如果右区间没有进行交换，左区间交换的元素往哪里放呢，此时i=j了，是不会进行从左到右扫描的
    5、在交换的过程中，始终有一个位置是留给tmp的，初始是在arr[0]上，之后进行交换时，交换出去的那个位置就是留给tmp的
    6、当i=j时，此时的i或j的位置就是tmp的位置，因为此时肯定是上一次交换之后剩下的位置
 
 空位置思想
    1、取出基准元素，该位置就是空位置
    2、在交换的过程中，始终有一个位置是空位置，供最后tmp赋值
    3、在判断当前位置大于或小于tmp时，将当前位置的元素赋出去，当前位置就是空位置了
    4、当i==j时，此时的i/j的位置就是最终的空位置，就将tmp放到这里
 */
void quickSort(NSMutableArray *arr,int s,int t){
    int i = s, j = t;
    NSString *tmp;
    if (s<t) {//区间内至少存在两个元素
        tmp = arr[s];//以第一个元素作为基准
        while (i!=j) {//从区间两端交替向中间扫描，直至i=j为止
            while (j>i && [arr[j] intValue]>=[tmp intValue]) {
                j--;//从右到左扫描，找到第一个小于tmp的值
            }
            //这里也一样，加判断i != j
            arr[i] = arr[j];//进行交换
            while (i<j && [arr[i] intValue] <= [tmp intValue]) {
                i++;//从左到右扫描，找到第一个大于tmp的值
            }
            //这里可以加一个判断优化一下，只有当i != j的时候才进行交换了。i==j交换也没啥用，只不过影响微不足道
            arr[j] = arr[i];//进行交换
        }
        arr[i] = tmp;//元素归位
        quickSort(arr, s,i-1);//左区间递归
        quickSort(arr, i+1,t);//右区间递归
    }
}



//归并排序
//先使每个子序列有序，再使子序列段间有序，再将多个序列表合并成一个有序序列表
/*
 一次归并
 1、将数组中的一组数据进行排序，通过low和high分割区间作为一个待排序的无序列表，
 2、使用mid将待比较区间分成左右区间两部分。
 3、将两个子序列合并成一个有序序列，通过一个临时数组接收
 4、将有序的临时数组存储到无序的待排序数组中
 */
//注：通过mid，将数组待比较部分分成两部分，low-mid和mid-high
void merge(NSMutableArray *arr,int low,int mid,int high){
    //i用来对左区间进行比较，j对右区间进行比较，k用来对临时数组的数据进行处理
    int i = low,j = mid+1,k=0;
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:1];
    while (i <= mid && j <= high) {
        if ([arr[i] intValue] <= [arr[j] intValue]) {
            arr2[k] = arr[i];
                 i++;k++;
        } else {
            arr2[k] = arr[j];
            j++;k++;
        }
    }
    while (i <= mid) {
        arr2[k] = arr[i];
        i++;k++;
    }
    while (j <= high) {
        arr2[k] = arr[j];
        j++;k++;
    }
    //再全部赋给arr
    for (k=0,i=low;i <= high ; k++,i++) {
        arr[i] = arr2[k];
    }
}

/*
 对整个表进行一趟归并
 当前表中的所有子序列进行归并
 通过子序列的长度来获取子序列
 */
void MergePass(NSMutableArray *arr,int length,int n){
    int i;
    //归并length长的两相邻子序列
    for (i=0; i+2*length-1<n; i=i+2*length) {
        merge(arr, i, i+length-1, i+2*length-1);
    }
    //最后一个子序列的长度小于length，需要特殊处理
    if (i+length-1<n) {
        merge(arr,i,i+length-1,n-1);//归并这两个子表
    }
}

/*
 对整个表分成多个子序列，初始子序列长度为1，后续每次加倍，之后调用归并函数进行归并
 故会进行lgn趟归并
 */
void mergeSort2(NSMutableArray *arr,int n){
    int length;
    //每次归并的序列端长度从1起始，每次加倍
    for (length = 1; length<n; length = 2*length) {//进行lgn趟归并
        MergePass(arr, length, n);
    }
    NSLog(@"mergeSort2:%@",arr);
}

//下面是便于理解，通过数组来进行归并
//归并排序
/*
 1、循环两个数组的每个元素，分别添加到接收数组中
 2、有三种情况，都没遍历完，遍历完数组1，遍历完数组2
 3、都没遍历完情况下，需要比较两个数组对应元素的大小，小的先存入，大的后存入（升序排序）
 */
//合并两个数组
NSArray* mergeArrayFirstList(NSArray *array1 ,NSArray *array2) {
    NSMutableArray *resultArray = [NSMutableArray array];
    NSInteger firstIndex = 0, secondIndex = 0;
    //可以看出一轮只能往接收数组中存入一个元素
    while (firstIndex < array1.count && secondIndex < array2.count) {
        if ([array1[firstIndex] floatValue] < [array2[secondIndex] floatValue]) {
            [resultArray addObject:array1[firstIndex]];
            firstIndex++;
        } else {
            [resultArray addObject:array2[secondIndex]];
            secondIndex++;
        }
    }
    while (firstIndex < array1.count) {
        [resultArray addObject:array1[firstIndex]];
        firstIndex++;
    }
    while (secondIndex < array2.count) {
        [resultArray addObject:array2[secondIndex]];
        secondIndex++;
    }
    return resultArray.copy;
}

//这里采用递归算法来合并试一下
/*
 1、拆分数组，拆分的所有数组只有一个元素
 2、合并数组，所有的数组两两合并，将合并的数组保存下来再与其他的数组合并，一直到只有一个数组
 */
//注：这里会把拆分的所有数组放到一个数组中，是为了更好的对这些数组进行归并操作
void megerSortAscendingOrderSort(NSMutableArray *ascendingArr)
{
    //tempArray数组里存放ascendingArr个数组，每个数组包含一个元素
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    for (NSString *num in ascendingArr) {
        NSMutableArray *subArray = [NSMutableArray array];
        [subArray addObject:num];
        [tempArray addObject:subArray];
    }
    //开始合并为一个数组
    while (tempArray.count != 1) {
        NSInteger i = 0;
        while (i < tempArray.count - 1) {
            //将后两个归并成一个数组，并保存到倒数第二个位置
            tempArray[i] = mergeArrayFirstList(tempArray[i], tempArray[i + 1]);
            //最后一个元素删掉
            [tempArray removeObjectAtIndex:i + 1];
            i++;
        }
    }
    NSLog(@"归并升序排序结果：%@", tempArray[0]);
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1",@"3",@"2",@"5",@"4", nil];
        //插入排序
//        insertSort(arr,5);
//        //折半插入排序
//        binaryInsertSort(arr,5);
        //冒泡排序
//        BubbleSort(arr, 5);
        //优化后冒泡排序
//        bubbleSort_better(arr,5);
        //快速排序
//        quickSort(arr,0,4);
//        NSLog(@"quickSort:%@",arr);
        //选择排序
//        selectSort(arr,5);
        //冒泡2
//        BubbleSort1(arr,5);
//        bubbleSort_better(arr,5);
        bubbleSort_better2(arr,5);
        //归并
//        megerSortAscendingOrderSort(arr);
//        mergeSort2(arr, 5);
        //堆排序
//        HeapSort(arr,4);
    }
    return 0;
}
