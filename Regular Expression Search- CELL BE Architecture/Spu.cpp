// CellBe.cpp : Defines the entry point for the console application.
//

#include "iostream"
#include "sstream"
using namespace std;
struct range{
	int start;
	int end;
};
struct findRepOut{
	range r ;
	int endIndex ;
};
class charRanged{
public:
	char a;
	int range_dif;
	charRanged(char b ,int rangedif){
		a= b;
		range_dif = rangedif;
	}
};
class regex{
	bool Terminator;
	public:
	charRanged **Chars;
	string regStr;
	char Type;
	range repRange;
	regex **regs;
	bool Not;
	int RgxCount;
	int charCount;
	public:

	findRepOut findRep(string rgx , int index);
	range repeat();
	string analyzeText(string txt);
	static string its(int num);
	static bool isTerm(char a);
	static char revSub(char a);
	static bool isSub(char a);
	static bool isMeta(char a);
	bool checkChar(char a);
	bool repSatis(int rep);
	int happenedAtIndex(int index , string txt);
	charRanged** terminatorParse();
	void breakRegex();
	regex(string regstr,bool term,char tp,range r1);
	regex(string regstr,bool term,char tp);
};
findRepOut	 regex::findRep(string rgx , int index){
	findRepOut fro;
	fro.endIndex =0;
	fro.r.end =0;
	char meta;
	fro.r.start = 0;
	string num = "";
	range ra;
	ra.end = 0;
	ra.start = 0;
	int i = index;
	index++;
	if ( rgx[index-1] != '{'){
		meta = rgx[index -1 ];
		fro.endIndex = index-1;
		if(meta == '*'){
			fro.r.start = 0;
			fro.r.end = -1;
		}
		if(meta == '?'){
			fro.r.start = 0;
			fro.r.end = 1;
		}
		if(meta == '+'){
			fro.r.start = 1;
			fro.r.end = -1;
		}
		return fro;
	}
	while( rgx[i] != ','){
		i++;
	}
	// index -- i-1
	num = rgx.substr(index , i - index );//cor
	ra.start = atoi(num.c_str());
	i++;
	index = i;
	while( rgx[i] != '}'){
		i++;
	}
	num = rgx.substr(index , i - index );//cor
	ra.end = atoi(num.c_str());
	fro.r = ra;
	fro.endIndex = i;
	return fro;

}
string       regex::its(int num){
	string Result;
	ostringstream convert;   // stream used for the conversion
	convert << num;      // insert the textual representation of 'Number' in the characters in the stream
	Result = convert.str(); // set 'Result' to the contents of the stream
	return Result;
}
bool		 regex::repSatis(int rep){
	bool ret;
	int start = 0;
	int end = 0 ;
	start = repRange.start;
	end = repRange.end;
	if( rep<start)
		return false;
	if(end == -1)
		return true;
	if(rep > end)
		return false;
	return true;
}
bool		 regex::isTerm(char a){
	if(a == '[')
		return true;
	if(a== '(')
		return false;
	cout<<"error in isTerm with char :"+ a;
	return false;
}
bool		 regex::isMeta(char a){
	if(a == '*' || a == '+' || a == '?' || a == '{')
		return true;
	return false;
}
bool		 regex::isSub(char a){
	if(a == '[' || a== '(')
		return true;
	return false;
}
bool		 regex::checkChar(char a){
	int c = 0 ;
	for(int i = 0 ; i< charCount; i++){
		c = (int)Chars[i][0].a;
		if((int)a>= c && a<= Chars[i][0].range_dif + c){
		return (true && !Not);
		}
	}
	return (false || Not);
}
char		 regex::revSub(char a){
	if(a=='[')
		return ']';
	if(a=='(')
		return ')';
	cout<<"Error in revSub";
	return '0';
}
void		 regex::breakRegex(){
	char cur ;
	int j = 0;
	int temp = 0;
	int count = 0;
	findRepOut fr1;
	bool backslashed = false;
	for(int i = 0 ; i< regStr.length() ; i++){
		cur = regStr[i];
		if(cur=='\\'){
			backslashed = true;
			continue;
		}
		if(cur=='.' && !backslashed){
			//regs[count] = new regex(regStr.substr(i , 1),isTerm(cur),'.');//cor
			if(i+1 < regStr.length()){
				fr1 = findRep(regStr,i+1);
			}
			i = fr1.endIndex;
			count++;
			continue;
		}
		if(isSub(cur) & !backslashed){
				j = i+1;
				temp = 1;
				while(temp != 0){
					if(regStr[j] == cur)
						temp++;
					if(regStr[j] == revSub(cur))
						temp--;
					j++;
				}
				if(j < regStr.length()){
					if(isMeta(regStr[j])){
						fr1 = findRep(regStr,j);
						//regs[count] = new regex(regStr.substr(i+1 , j-i-1),isTerm(cur),regStr[j],fr1.r); //cor
						count++;
						j = fr1.endIndex;
						i = j;
						continue;
					}
					else{
						//regs[count] = new regex(regStr.substr(i+1 , j-i-1),isTerm(cur),'0'); //cor
						count++;
						i = j-1;
						continue;
					}
				}
				else{
						//regs[count] = new regex(regStr.substr(i+1 , j-i-1),isTerm(cur),'0'); // cor
						count++;
						i = j-1;
						continue;
				}

		}
		else{
			if(i+1 <regStr.length()){
				if(isMeta(regStr[i+1])){
					fr1 = findRep(regStr ,i+1);
					//regs[count] = new regex(regStr.substr(i,1) , true ,regStr[i+1],fr1.r);//cor
					count++;
					i = fr1.endIndex;
				//	i = i+1;
					backslashed = false;
					continue;
				}
				else{
					//regs[count] = new regex(regStr.substr(i,1) , true ,'0');//cor
					count++;
					backslashed = false;
					continue;
				}
			}
			else{
//				regs[count] = new regex(regStr.substr(i, 1) , true , '0');//cor
				count++;
				backslashed = false;
				continue;
			}
		}
	}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	j = 0;
	temp = 0;
	fr1.r.start = 1;
	fr1.r.end = 1;
	RgxCount = count;
	regs = new regex*[count];
	count = 0;
	 backslashed = false;
	for(int i = 0 ; i< regStr.length() ; i++){
		fr1.r.start = 1;
		fr1.r.end = 1;
		cur = regStr[i];
		if(cur=='\\'){
			backslashed = true;
			continue;
		}
		if(cur=='.' && !backslashed){
			if(i+1 < regStr.length()){
				fr1 = findRep(regStr,i+1);
			}
			regs[count] = new regex(regStr.substr(i , 1),true,'.',fr1.r);//cor
			regs[count][0].Not = true;
			regs[count][0].Chars[0][0].a = '\0';
			count++;
			i = fr1.endIndex;
			continue;
		}
		if(isSub(cur) & !backslashed){
				j = i+1;
				temp = 1;
				while(temp != 0){
					if(regStr[j] == cur)
						temp++;
					if(regStr[j] == revSub(cur))
						temp--;
					j++;
				}
				if(j < regStr.length()){
					if(isMeta(regStr[j])){
						fr1 = findRep(regStr,j);
						regs[count] = new regex(regStr.substr(i+1 , j-i-2),isTerm(cur),regStr[j],fr1.r); //cor
						count++;
						j = fr1.endIndex;
						i = j;
						continue;
					}
					else{
						fr1.r.end = 1;
						fr1.r.start = 1;
						regs[count] = new regex(regStr.substr(i+1 , j-i-2),isTerm(cur),'0',fr1.r); //cor
						count++;
						i = j-1;
						continue;
					}
				}
				else{
					fr1.r.start = 1;
					fr1.r.end = 1;
					regs[count] = new regex(regStr.substr(i+1 , j-i-2),isTerm(cur),'0',fr1.r); // cor
						count++;
						i = j-1;
						continue;
				}

		}
		else{
			if(i+1 <regStr.length()){
				if(isMeta(regStr[i+1])){
					fr1 = findRep(regStr ,i+1);

					regs[count] = new regex(regStr.substr(i,1) , true ,regStr[i+1],fr1.r);//cor

					count++;
					i = fr1.endIndex;
					backslashed = false;
					continue;
				}
				else{
					fr1.r.start = 1;
					fr1.r.end = 1;

					regs[count] = new regex(regStr.substr(i,1) , true ,'0',fr1.r);//cor

					count++;
					backslashed = false;
					continue;
				}
			}
			else{
				regs[count] = new regex(regStr.substr(i, 1) , true , '0',fr1.r);//cor
				count++;
				backslashed = false;
				continue;
			}
		}
	}
}
			 regex::regex(string regstr , bool term , char tp){
		 regStr = regstr;
		 RgxCount = 0;
		 repRange.end = 1;
		 repRange.start = 1;
		 Terminator = term;
		 Type = tp;
		 if(term){
			 Chars = terminatorParse();
		 }
		 else{
			breakRegex();
		 }
}
			 regex::regex(string regstr , bool term , char tp , range r1){
		regStr = regstr;
		RgxCount = 0;
		Not = false;
		charCount = 0;
		 Terminator = term;
		 Type = tp;
		 repRange = r1;
		 if(term){
			 Chars = terminatorParse();
		 }
		 else{
			breakRegex();
		 }
	 }
charRanged** regex::terminatorParse(){
		int i = 0 ;
		int count = 0;
		charRanged** ret;
		bool bslash = false;
		if(regStr[0] == '^'){
			Not = true;
			i++;
		}
		for(i =i ; i < regStr.length() ; i++){
			if(regStr[i] == '\\'){
				bslash = true;
				continue;
			}



			if(i+1 < regStr.length()){
				if(regStr[i+1] == '-'){
			//		ret[count] = new charRanged(regStr[i] , regStr[i+2] - regStr[i]);
					count++;
					bslash = false;
					i = i+2;
					continue;
				}
			}

			//ret[count] = new charRanged(regStr[i] , 0);
			count++;
			continue;
		}
		//////////////////////////////////////////////////////////////////
		//
		i =0;
		charCount = count;
		ret = new charRanged*[count];
		count = 0;
		bslash = false;
		if(regStr[0] == '^'){
			Not = true;
			i++;
		}
		for(i =i ; i < regStr.length() ; i++){
			if(regStr[i] == '\\' ){
				bslash = true;
				continue;
			}



			if(i+1 < regStr.length() && !bslash){
				if(regStr[i+1] == '-'){
					ret[count] = new charRanged(regStr[i] , regStr[i+2] - regStr[i]);
					count++;
					bslash = false;
					i = i+2;
					continue;
				}
			}

			ret[count] = new charRanged(regStr[i] , 0);


			count++;
		}
		///////////////////////////////////////////////////////////////
		return ret;
	 }

string		 regex::analyzeText(string txt){
		string ret = "";
		string te = txt;

		int end;
		bool found =false;
		int count = 0;

	for(int i = 0 ; i < txt.length() ; i++){
		end = happenedAtIndex(i , txt);
		if(end== -1)
			continue;
		ret +="happened at index : "+its(i) + "   " + te.substr(i , end -i)+"\n";
		found = true;
		count++;
	}
	if(!found)
		ret = "text Not found";
	ret = its(count) +"\n" + ret;
	return ret;
}


typedef struct{
	regex* regx;
	const char* text;
	int index;
	int *endspu;
	int lenght;
	char dummy[108];
}spuData;


int	main(unsigned long long speid,unsigned long long argp,unsigned long long envp ){
	int index __attribute__((aligned(128)));
	int lenght __attribute__((aligned(128)));
	const char* txt __attribute__((aligned(128)));
	char currentChar;
	spuData mystruct __attribute__((aligned(128)));
	char textSample ;
	int tag=1,tag_mask=1<<tag;
	mfc_get(&mystruct,(unsigned int)argp,envp,tag,0,0);
	mfc_write_tag_mask(tag_mask);
	mfc_read_tag_status_all();


	index = mystruct.index;
	lenght=mystruct.lenght;
	txt=mystruct.text;
	mfc_read_tag_status_all();

	int rep = 0;
	int i = 0 ;
	int temp = index;
	if(index >= length)
		return -1;
	bool breakFlag = false;
	int temp2 = repRange.end;
	if(Terminator){

		for( i = index ; i < lenght; i++){
			mfc_get(&currentChar,mystruct.text+i,1,tag,0,0);
			mfc_read_tag_status_all();
			if(!checkChar(currentChar)) {
				break;
			}
			rep++;
			if(rep== temp2)
				return i+1;

		}
		if(repSatis(rep))
			return i;
		return -1;

	}

	else{
			temp2 = index;
		while(rep != repRange.end){

			breakFlag = false;
			for(int j =0  ; j< RgxCount ; j++){
				temp = regs[j][0].happenedAtIndex(temp,txt,lenght);
				if(temp == -1){
					temp = temp2;
					breakFlag = true;
					break;
				}
			}
			if(breakFlag){
				break;
			}
			temp2 = temp;
			rep++;
		}

			if(!repSatis(rep))
				return -1;
			mfc_put(&temp,mystruct.endspu,4,tag,0,0);
			mfc_read_tag_status_all();
			return 0;
		}

	}
int			 regex::happenedAtIndex(int index , const char* txt,int lenght){
	int rep = 0;
	int i = 0 ;
	int temp = index;
	char currentChar;
	if(index >= length())
		return -1;
	bool breakFlag = false;
	int temp2 = repRange.end;
	if(Terminator){

		for( i = index ; i < length(); i++){
			mfc_get(&currentChar,txt+i,1,tag,0,0);
			mfc_read_tag_status_all();
			if(!checkChar(currentChar)) {
				break;
			}
			rep++;
			if(rep== temp2)
				return i+1;

		}
		if(repSatis(rep))
			return i;
		return -1;

	}

	else{
			temp2 = index;
		while(rep != repRange.end){

			breakFlag = false;
			for(int j =0  ; j< RgxCount ; j++){
				temp = regs[j][0].happenedAtIndex(temp,txt,lenght);
				if(temp == -1){
					temp = temp2;
					breakFlag = true;
					break;
				}
			}
			if(breakFlag){
				break;
			}
			temp2 = temp;
			rep++;
		}

			if(!repSatis(rep))
				return -1;
			return temp;
		}

	}
