# 26. 删除有序数组中的重复项

## 给你一个有序数组 nums ，请你 原地 删除重复出现的元素，使每个元素 只出现一次 ，返回删除后数组的新长度。
## 不要使用额外的数组空间，你必须在 原地 修改输入数组 并在使用 O(1) 额外空间的条件下完成。

### 有序数组，如果可以使用额外数组，则可以使用unodered_map<int>记录出现次数，遍历一遍，将重复出现的于数组右测元素交换
### 题目要求原地修改，使用双指针，left和right  
    left左侧为已检验过的元素，right用于遍历和交换数组  
    由于是有序数组，所以重复元素是连续出现的（122234444566），当right指针和left指针元素相等，则一直向右移动右指针。当不相等，则进入了下一个区间，将左指针右移1，交换左右指针的值  
    即将重复的元素放到后面去，未重复的元素放到前面。（左右指针中间的数是重复的数）

## C++实现  
```
class Solution {
public:
    int removeDuplicates(vector<int>& nums) {  
        //排序
       // sort(nums.begin(),nums.end());
       if(nums.empty())return {};
        int left=0,right=0;
        while(right<nums.size()){
            if(nums[right]!=nums[left]){
                left++;
                int tmp=nums[left];
                nums[left]=nums[right];
                nums[right]=tmp;
                
            }
            right++;
        }
        return left+1;
    }
};
```

# 309. 最佳买卖股票时机含冷冻期
## 股票买卖题一般都是动态规划，找到状态转移方程是关建  
    假设f是今天结束后的收益  
	f[i][0]是继续持有股票的收益
	f[i][1]是卖出股票的收益   
	状态转移方程则为
	f[i][0]=f[i-1][0]
	f[i][1]=f[i-1][0]+price[i]
	初始状态
	f[0][0]=-price[0]
	f[0][1]=0
	加了约束条件的话就会多增加几个状态最后返回几种状态中的最大
## C++实现
```
class Solution {
public:
    int maxProfit(vector<int>& prices) {
        vector<vector<int>> f(prices.size(),vector<int>(3,0));
        f[0][0]=-prices[0];
        f[0][1]=0;
        f[0][2]=0;
        for(int i=1;i<prices.size();i++){
        //三种情况 持有 未持有-冷冻期  未持有-非冷冻期
            f[i][0]=max(f[i-1][0],f[i-1][2]-prices[i]);
            f[i][1]=f[i-1][0]+prices[i];
            f[i][2]=max(f[i-1][1],f[i-1][2]);
        }
        return max(max(f[prices.size()-1][0],f[prices.size()-1][1]),f[prices.size()-1][2]);
        
    }
};
```

# 27. 移除元素
## 给你一个数组 nums 和一个值 val，你需要 原地 移除所有数值等于 val 的元素，并返回移除后数组的新长度。  
	不要使用额外的数组空间，你必须仅使用 O(1) 额外空间并 原地 修改输入数组。
	
	原地修改数组，所以不可以用新的数组存储符合条件要求，可用双指针（和26思路一样），把符合要求的元素的放到left指针前面，right指针用于遍历数组
	

# C++实现
```
class Solution {
public:
    int removeElement(vector<int>& nums, int val) {
        int left=0;
        int right=0;
        while(right<nums.size()){
            if(nums[right]!=val){
                int tmp=nums[left];
                nums[left]=nums[right];
                nums[right]=tmp;
                left++;
            }
            right++;
        }
        return left;
    }
};
```
# 75. 颜色分类
	给定一个包含红色、白色和蓝色，一共 n 个元素的数组，原地对它们进行排序，使得相同颜色的元素相邻，并按照红色、白色、蓝色顺序排列。
	此题中，我们使用整数 0、 1 和 2 分别表示红色、白色和蓝色。

	可以用单指针遍历两次，找0和2分别放到首部和尾部
	也可以用双指针遍历一次
	1、找0和1，用两个指针p0和p1来存0和1的位置，从左到右遍历数组，找到1则和p1交换，p1加1；找到0则和p0交换，但此时p0和p1都要加1（如果p1>p0，此时交换出来的nums[i]是1，还要再赋给p1才能给p1加1）
#C++实现
```
class Solution {
public:
    void sortColors(vector<int>& nums) {
        int p0=0;
        int p1=0;
        for(int i=0;i<nums.size();i++){
            if(nums[i]==0){
                int tmp=nums[p0];
                nums[p0]=nums[i];
                nums[i]=tmp;
                if(nums[i]==1){
                    int tmp=nums[p1];
                    nums[p1]=nums[i];
                    nums[i]=tmp;
                    
                }
                p0++;
                p1++;
                
            }
            else if(nums[i]==1){
                int tmp=nums[p1];
                nums[p1]=nums[i];
                nums[i]=tmp;
                p1++;
            }
        }
    }
};
```
	2、找0和2，0往头部扔，2往尾部扔。同样从左往右遍历数组，但此时和p2交换出来的元素可能还是2，但下标已经到了i+1，所以需要循环交换，直到p2不为2为止
		注意要先用while判断2，这样剩下的nums[i]只能是0和1，就不需要用循环来交换
# C++
```
class Solution {
public:
    void sortColors(vector<int>& nums) {
        int  left=0;
        int right=nums.size()-1;
        int i=0;
        while(i<=right){
            
            while(i<=right&&nums[i]==2){
                swap(nums[i],nums[right]);
                right--;
            }
                if(nums[i]==0){
                swap(nums[i],nums[left]);
                left++;
            }
            i++;
            }
        }
    
};
```

# 28. 实现 strStr()
	给你两个字符串 haystack 和 needle ，请你在 haystack 字符串中找出 needle 字符串出现的第一个位置（下标从 0 开始）。如果不存在，则返回  -1 。
	字符串匹配问题，最直观的思路是暴力法遍历字符串每一作为起点的位置，判断是否匹配
# C++实现
```
class Solution {
public:
    int strStr(string haystack, string needle) {
        if(needle==""){return 0;}
        int m=haystack.size();
        int n=needle.size();
        for(int i=0;i<(m-n+1);i++){
            int j=0;
            for(;j<n;j++){
                if(haystack[i+j]!=needle[j]){
                    break;
                }
            }
            
            if(j==n){
                return i;
            }
        }
        return -1;
    }
};
```
	可使用KMP算法进行优化，KMP算法是构建了一个前缀表，记录该元素的前缀中的最长真前缀和真后缀相等的长度len，当发生不匹配时，将指针移动到模式串的len出继续匹配
	这样子减少了不必要的重复匹配，提高效率
	难点是前缀表的建立。
	
	
# 437. 路径总和 III
	给定一个二叉树，它的每个结点都存放着一个整数值。
	找出路径和等于给定数值的路径总数。
	路径不需要从根节点开始，也不需要在叶子节点结束，但是路径方向必须是向下的（只能从父节点到子节点）
	
	要考虑包含root节点和不包含root节点两种情况，传的参分别为targetsum和targetsum-rootval，所以需要两个递归
```
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
   
    int pathSum(TreeNode* root, int targetSum) {
       return root? dfs_withroot(root, targetSum) + pathSum(root->left, targetSum) + pathSum(root->right, targetSum): 0;
    }
    int dfs_withroot(TreeNode* root, int targetSum){
        if(root==nullptr){return 0;}
        int res=0;
        if(root->val==targetSum){res++;}
        res+= dfs_withroot(root->left,targetSum-root->val);
        res += dfs_withroot(root->right,targetSum-root->val);
        return res;
    }
};
```

# 91. 解码方法
	题目太长就不贴了
	
	主要思路就是动态规划，当当前字符不等于0时，他自己肯定可以解码出一个符号，所以必有dp[i]=dp[i-1]（dp为前i个字符组成的字符串能够解码的种类）
	当当前字符和前一字符组成<=26并且s[i-1]不等于0（即不是01，02，这样0开头的）那么这两个数也可以组成一种字符 即dp[i]=dp[i-2]
	结合两种情况，将两种情况加起来
	
# C++实现 
```
class Solution {
public:
    int numDecodings(string s) {
        if(s[0]=='0'){return 0;}
        vector<int> dp(s.size()+1,0);
        dp[1]=1;
        dp[0]=1;
        for(int i=1;i<s.size();i++){
            if(s[i]=='0'){
                if(s[i-1]=='1'||s[i-1]=='2'){
                    dp[i+1]=dp[i-1];
                }
            }
            else if(s[i]>='1'&&s[i]<='6'){
                if(s[i-1]=='1'||s[i-1]=='2'){
                    dp[i+1]=dp[i-1];
                }
                dp[i+1]+=dp[i];
            }
            else if(s[i]>'6'){
                if(s[i-1]=='1'){
                    dp[i+1]=dp[i-1];
                }
                dp[i+1]+=dp[i];
            }

        }

        return dp[s.size()];
    }
};
```

# 363. 矩形区域不超过 K 的最大数值和
	给你一个 m x n 的矩阵 matrix 和一个整数 k ，找出并返回矩阵内部矩形区域的不超过 k 的最大数值和。
	
	前缀和思路，创建一个二位数组，sum[i][j]表示以ij为右下角端点的矩形内部和大小，然后进行暴力搜索
	固定左上角，遍历所有右下角，找最接近k的内部和
	使用vector会超时！换成数组可以通过
# C++实现
```
class Solution {
public:
    int maxSumSubmatrix(vector<vector<int>>& matrix, int p) {
        int res=INT_MIN;
        vector<vector<int>> matric_sum(matrix.size()+1,vector<int>(matrix[0].size()+1,0));
		// int matric_sum[101][101];
        
        for(int i=1;i<=matrix.size();i++){
            for(int j=1;j<=matrix[0].size();j++){
                matric_sum[i][j]=matric_sum[i][j-1]+matric_sum[i-1][j]-matric_sum[i-1][j-1]+matrix[i-1][j-1];
            }
        }
         for(int i=1;i<=matrix.size();i++){
            for(int j=1;j<=matrix[0].size();j++){
                    //起点
                for(int k=i;k<=matrix.size();k++){
                    for(int l=j;l<=matrix[0].size();l++){
                        //终点
                        int sum=matric_sum[k][l]-matric_sum[i-1][l]-matric_sum[k][j-1]+matric_sum[i-1][j-1] ;
 
                        if(sum<=p){
                            
                            res=max(res,sum);
                        }
                }
                    }
            }
        }
        return res;
    }
};
```

# 368. 最大整除子集
	给你一个由 无重复 正整数组成的集合 nums ，请你找出并返回其中最大的整除子集 answer ，子集中每一元素对 (answer[i], answer[j]) 都应当满足：
	answer[i] % answer[j] == 0 ，或
	answer[j] % answer[i] == 0
	
	动态规划思路，如果当前值能除以一个整除数组的最大值，那他属于这个整除数组，因此先对这个数组排序，从小到大
	用一个二维dp数组存储以当前元素结尾的最大整除数组，对每一个元素，从前一个元素往前遍历数组，如果当前元素能被整除，则把自己加入当前元素的整除数组，并判断大小是否为最大。
	转移方程：
		if(tmp_len<dp[j].size()){
			tmp_len=dp[j].size();
			dp[i]=dp[j];
        }
		dp[i].push_back(nums[i]);

```
class Solution {
public:
    vector<int> largestDivisibleSubset(vector<int>& nums) {
        sort(nums.begin(),nums.end());
        int res=0;
        int max_len=0;
        vector<vector<int>> dp(nums.size());
        dp[0].push_back(nums[0]);
        for(int i=1;i<nums.size();i++){
            int tmp_len=0;
            for(int j=i-1;j>=0;j--){
                if(nums[i]%nums[j]==0){
                    if(tmp_len<dp[j].size()){
                        tmp_len=dp[j].size();
                        dp[i]=dp[j];
                    }
                }
            }
            dp[i].push_back(nums[i]);
            if(dp[i].size()>max_len){
                max_len=dp[i].size();
                res=i;
            }
        }
        return dp[res];
    }
};
```
	也可以用时间换空间
	dp数组表示最大整除数组的长度，先遍历数组，找到最大整除数组的长度和最大值
	遍历数组，将能被最大值整除的元素压入数组，倒推获得最大数组
	
```
class Solution {
public:
    vector<int> largestDivisibleSubset(vector<int>& nums) {
        int len = nums.size();
        sort(nums.begin(), nums.end());

        // 第 1 步：动态规划找出最大子集的个数、最大子集中的最大整数
        vector<int> dp(len, 1);
        int maxSize = 1;
        int maxVal = dp[0];
        for (int i = 1; i < len; i++) {
            for (int j = 0; j < i; j++) {
                // 题目中说「没有重复元素」很重要
                if (nums[i] % nums[j] == 0) {
                    dp[i] = max(dp[i], dp[j] + 1);
                }
            }

            if (dp[i] > maxSize) {
                maxSize = dp[i];
                maxVal = nums[i];
            }
        }

        // 第 2 步：倒推获得最大子集
        vector<int> res;
        if (maxSize == 1) {
            res.push_back(nums[0]);
            return res;
        }

        for (int i = len - 1; i >= 0 && maxSize > 0; i--) {
            if (dp[i] == maxSize && maxVal % nums[i] == 0) {
                res.push_back(nums[i]);
                maxVal = nums[i];
                maxSize--;
            }
        }
        return res;
    }
};

```

# 377. 组合总和 Ⅳ

	给你一个由 不同 整数组成的数组 nums ，和一个目标整数 target 。请你从 nums 中找出并返回总和为 target 的元素组合的个数。
	题目数据保证答案符合 32 位整数范围
	
	排列组合的个数主要思路就是回溯和动态规划，因为可以重复使用同一个元素无数次，回溯不太适用。
	假设dp[i]为目标i的组合个数，那么dp[i]等于所有dp[i-num]的和，即组成目标数减去数组中一个小于i的数的组合个数有多少个
	
#C++ 实现
```
class Solution {
public:
    int combinationSum4(vector<int>& nums, int target) {
        vector<int>dp(target +1);
        dp[0]=1;
        for(int i=1;i<=target;i++){
            for(int j=0;j<nums.size();j++){
                if(nums[j]<=i && dp[i-nums[j]]<INT_MAX-dp[i]){
                    dp[i]+=dp[i-nums[j]];
                }
            }
        }
        return dp[target];
    }
};
```

# 897. 递增顺序搜索树
    给你一棵二叉搜索树，请你 按中序遍历 将其重新排列为一棵递增顺序搜索树，使树中最左边的节点成为树的根节点，并且每个节点没有左子节点，只有一个右子节点。
	
	最直接的思路就是中序遍历搜索树，用个数组存储所有节点，然后将数组重新排列成一颗顺序树
```
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    TreeNode* increasingBST(TreeNode* root) {
        vector<TreeNode*> tree;
        dfs(root,tree);
        TreeNode *head =new TreeNode(0);

        TreeNode *res=head;
        for(auto t:tree){
            TreeNode *trees =new TreeNode(t->val);
            head->right=trees;
            head=trees;
        }
        return res->right;
    }
    void dfs(TreeNode*root, vector<TreeNode *> &tree){
        if(root==nullptr){return;}
        dfs(root->left,tree);
        tree.push_back(root);
        dfs(root->right,tree);
    }
};
```

	也可以边遍历边排序
```
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    TreeNode* resnode=nullptr;
    TreeNode* increasingBST(TreeNode* root) {
        TreeNode * head=new TreeNode(0);
        resnode=head;
        TreeNode *res=head;
        dfs(root);
        return res->right;
    }
    void dfs(TreeNode* root){
        if(root==nullptr){
            return ;
        }
        dfs(root->left);
        resnode->right=root;
        root->left=nullptr;
        resnode=root;
        dfs(root->right);
        
    }
};
```
# 1011. 在 D 天内送达包裹的能力
	传送带上的包裹必须在 D 天内从一个港口运送到另一个港口。
	传送带上的第 i 个包裹的重量为 weights[i]。每一天，我们都会按给出重量的顺序往传送带上装载包裹。我们装载的重量不会超过船的最大运载重量。
	返回能在 D 天内将传送带上的所有包裹送达的船的最低运载能力
	
	船的运送能力必须比所有货物的最大值大，也得比货物总和/天数大才可以运送完，同时运送能力没必要比货物总和大，由此缺点了运载能力的上下界
	然后就是遍历这个范围内的值，缺点一个符合条件的最小运载能力————因此使用二分查找降低查找范围
```
class Solution {
public:
    int shipWithinDays(vector<int>& weights, int D) {
        //lower_bound =weights/D
        //upper_bound =weight
        int sum=accumulate(weights.begin(),weights.end(),0);
        int largest =*max_element(weights.begin(),weights.end());
        int left=max(sum/D,largest);
        int right=sum;
        int mid=(right+left)/2;
        while(left<right){
            mid=(right+left)/2;
            int day=0;
            int tmp_sum=0;
            for(int i=0;i<weights.size();i++){
                
                tmp_sum+=weights[i];
                if(tmp_sum > mid){
                    day++;
                    i--;
                    tmp_sum=0;
                }
                else if(tmp_sum==mid){
                    day++;
                    tmp_sum=0;
                }
                else if(i==weights.size()-1){
                    day++;
                }
                
            }
            cout<<day<<" "<<mid<<" "<<left<<" "<< right<<endl;
            if(day > D){
               left=mid+1; 
            }
            else if(day<=D){
                right=mid;
            }
        }
        return left;
    }
};
```

# 938. 二叉搜索树的范围和

	给定二叉搜索树的根结点 root，返回值位于范围 [low, high] 之间的所有结点的值的和。
	
	直接中序遍历，找到符合条件的节点值加上即可；也可使用广度优先搜索，利用队列完成
```
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode() : val(0), left(nullptr), right(nullptr) {}
 *     TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
 *     TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
 * };
 */
class Solution {
public:
    int res=0;
    int rangeSumBST(TreeNode* root, int low, int high) {
        dfs(root,low,high);
        return res;
    }
    void dfs(TreeNode* root,int low,int high){
        if(root== nullptr){return;}

        if(root->val >low){
            dfs(root->left,low,high);
        }
        if(root->val >=low&& root->val <=high){
            res+=root->val;
        }
        if(root->val < high){
            dfs(root->right,low,high);
        }
    }
};
```

# 3. 无重复字符的最长子串

	给定一个字符串，请你找出其中不含有重复字符的 最长子串 的长度。

	动态规划
	用一个哈希表存储已出现字符的下标，用一个数组记录当前字符为结尾的最长无重复子串，如果当前字符没有出现过，则长度+1，如果出现过，则判断
	出现的位置是否在前一个元素记录的最长子串范围内，不在则直接+1，在则最长无重复子串长度为从元素的位置到当前位置-1；
```
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        unordered_map<char,int> freq;
        int res=0;
        vector<int> dp(s.size()+1,0);//这个字符最后出现的位置
        dp[0]=0;
        for(int i=1;i<=s.size();i++){
            if(freq.find(s[i-1])==freq.end()){
                dp[i]=dp[i-1]+1;
                freq[s[i-1]]=i-1;
            }
            else{
                if(freq[s[i-1]]<(i-1-dp[i-1])){
                    //上次出现的位置不在上一个字符子串范围内
                    dp[i]=dp[i-1]+1;
                }
                else
                dp[i]=(i-1)-freq[s[i-1]];
                freq[s[i-1]]=i-1;
            }
            res=max(res,dp[i]);
        }
        return res;
    }
};
```
	滑动窗口
	用一个哈希表或哈希set存储已出现字符；用两个指针指向窗口左右，当右指针指向的元素未出现过，则右指针+1，压入该元素；出现过，则左指针+1，并且弹出该元素
```
	class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        // 哈希集合，记录每个字符是否出现过
        unordered_set<char> occ;
        int n = s.size();
        // 右指针，初始值为 -1，相当于我们在字符串的左边界的左侧，还没有开始移动
        int rk = -1, ans = 0;
        // 枚举左指针的位置，初始值隐性地表示为 -1
        for (int i = 0; i < n; ++i) {
            if (i != 0) {
                // 左指针向右移动一格，移除一个字符
                occ.erase(s[i - 1]);
            }
            while (rk + 1 < n && !occ.count(s[rk + 1])) {
                // 不断地移动右指针
                occ.insert(s[rk + 1]);
                ++rk;
            }
            // 第 i 到 rk 个字符是一个极长的无重复字符子串
            ans = max(ans, rk - i + 1);
        }
        return ans;
    }
};

```

# 690. 员工的重要性
	给定一个保存员工信息的数据结构，它包含了员工 唯一的 id ，重要度 和 直系下属的 id 。
	比如，员工 1 是员工 2 的领导，员工 2 是员工 3 的领导。他们相应的重要度为 15 , 10 , 5 。那么员工 1 的数据结构是 [1, 15, [2]] ，员工 2的 数据结构是 [2, 10, [3]] ，员工 3 的数据结构是 [3, 5, []] 。注意虽然员工 3 也是员工 1 的一个下属，但是由于 并不是直系 下属，因此没有体现在员工 1 的数据结构中。
	现在输入一个公司的所有员工信息，以及单个员工 id ，返回这个员工和他所有下属的重要度之和。
	
	哈希表+BFS
```
/*
// Definition for Employee.
class Employee {
public:
    int id;
    int importance;
    vector<int> subordinates;
};
*/

class Solution {
public:
    int getImportance(vector<Employee*> employees, int id) {
        unordered_map<int,Employee*> important;
        int target=0;
        deque<int> sub;
        for(auto employee:employees){
            important[employee->id]=employee;
        }
        sub.push_back(id);
        int sum=important[id]->importance;
        while(!sub.empty()){
            int len=sub.size();
            for(int i=0;i<len;i++){
                int cur=sub.front();
                sub.pop_front();
                for(int j=0;j<important[cur]->subordinates.size();j++){
                    sum+=important[important[cur]->subordinates[j]]->importance;
                    if(!important[important[cur]->subordinates[j]]->subordinates.empty()){
                        sub.push_back(important[cur]->subordinates[j]);
                    }
                }
            }

        }
        return sum;
    }
};
```
# 5. 最长回文子串 !
	动态规划法
```
class Solution {
public:
    string longestPalindrome(string s) {
        //动态规划/中心拓展
        int len =s.size();
        if(len==1) return s;
        vector<vector<bool>> dp(len,vector<bool>(len,false));//dp[i][j]以i开始j结尾的数是否未回文数
        string result="";
        for(int i=len-1;i>=0;i--){
            for(int j=i;j<len;j++){
                if(j==i){dp[i][j]=true;}
                else if(s[i]==s[j]){
                    if(j-i==1)dp[i][j]=true;
                    else{
                        dp[i][j]=dp[i+1][j-1];
                    }
                    
                }
                if(dp[i][j]==true&&(j-i+1)>result.size()){
                    result=s.substr(i,j-i+1);
                }
            }
        }
        return result;
    }
};
```