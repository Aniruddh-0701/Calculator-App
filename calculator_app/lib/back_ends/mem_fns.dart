// Functions associated with calculator memory
var eqn;

// AC
void ac(){
  eqn = [];
}

//bksp
void bksp(){
  if (eqn.last.length == 1)
    eqn.removeLast();
  else
    eqn.last = eqn.last.substring(0, eqn.last.length -1);
}

void main(){
  eqn = ['10'];
  bksp();
  print(eqn);
}
