/*
PROB: score
LANG: C++
*/

#include <iostream.h>

const int MAX=1000;

int start_position_passed;
int number_of_positions;
int start_position;
int current_position;

int owner_of_the_position[MAX];
int value_of_the_position[MAX];
int adjacency_matrix[MAX][MAX];

int player_strategy[MAX];

int dfs_number[MAX];
int dfs_counter;
int player_I_max[MAX];
int player_II_max[MAX];

void search(int position) {
  dfs_number[position]=dfs_counter;
  dfs_counter++;
  int player_I_wins[MAX];
  int player_II_wins[MAX];
  for (int i=0;i<number_of_positions;i++){
    player_I_wins[i]=-1;
    player_II_wins[i]=-1;
  }

  for (int i=0;i<number_of_positions;i++) {
    if (adjacency_matrix[position][i] !=0) {
      if (dfs_number[i]==-1) {
	search(i);
	if (player_I_max[i]>player_II_max[i]) {
	  player_I_wins[i]=player_I_max[i];
	}
	else if (player_I_max[i]<player_II_max[i]) {
	  player_II_wins[i]=player_II_max[i];
	}
	else {
	}
      }
      else {
	if (player_I_max[i]>player_II_max[i]) {
	  player_I_wins[i]=player_I_max[i];
	}
	else if (player_I_max[i]<player_II_max[i]) {
	  player_II_wins[i]=player_II_max[i];
	}
	else {
	}
      }
    }
  }
  int j=-1;
  int max_score=-1;
  int opponent_min_score=-1;
  if (owner_of_the_position[position]==1) {
    for (int i=0;i<number_of_positions;i++) {
      if (player_I_wins[i]>-1) {
	if (player_I_wins[i]>max_score) {
	  max_score=player_I_wins[i];
	  j=i;
	}
      }
    }
    if (j != -1) {
      player_strategy[position]=j;
      
      player_I_max[position]=max_score;
      player_II_max[position]=player_II_max[j];
      
      if (value_of_the_position[position]>max_score) {
	player_I_max[position]=value_of_the_position[position];
      }
    }
    else {
      for (int i=0;i<number_of_positions;i++) {
	if (player_II_wins[i]>-1 && opponent_min_score==-1) {
	  opponent_min_score=player_II_wins[i];
	  j=i;
	}
	else if (player_II_wins[i]>-1 && player_II_wins[i]<opponent_min_score) {
	  opponent_min_score=player_II_wins[i];
	  j=i;
	}
	else {
	}
      }
    }    
    player_strategy[position]=j;
    player_I_max[position]=player_I_max[j];
    player_II_max[position]=opponent_min_score;
    if (value_of_the_position[position]>player_I_max[position]) {
      player_I_max[position]=value_of_the_position[position];
    }
  }
  else {
    for (int i=0;i<number_of_positions;i++) {
      if (player_II_wins[i]>-1) {
	if (player_II_wins[i]>max_score) {
	  max_score=player_II_wins[i];
	  j=i;
	}
      }
    }
    if (j != -1) {
      player_strategy[position]=j;
      player_II_max[position]=max_score;
      player_I_max[position]=player_I_max[j];
      if (value_of_the_position[position]>max_score) {
	player_II_max[position]=value_of_the_position[position];
      }
    }
    else {
      for (int i=0;i<number_of_positions;i++) {
	
	if (player_I_wins[i]>-1 && opponent_min_score==-1) {
	  opponent_min_score=player_I_wins[i];
	  j=i;
	}
	else if (player_I_wins[i]>-1 && player_I_wins[i]<opponent_min_score) {
	  opponent_min_score=player_I_wins[i];
	  j=i;
	}
	else {
	} 
      } 
      player_strategy[position]=j;
      player_II_max[position]=player_II_max[j];
      player_I_max[position]=opponent_min_score;
      if (value_of_the_position[position]>player_II_max[position]) {
	player_II_max[position]=value_of_the_position[position];
      }
    }
  }
}

void construct_strategy() {
  dfs_counter=0;
  for (int i=0;i<number_of_positions;i++) {
    if (owner_of_the_position[i]==1) {
      player_I_max[i]=value_of_the_position[i];
      player_II_max[i]=0;
    }
    else if (owner_of_the_position[i]==2) {
      player_I_max[i]=0;
      player_II_max[i]=value_of_the_position[i];
    }
    else {
    }
    dfs_number[i]=-1;
  }
  search(0);
}


void p1_move(int move)
{
  if (move==start_position)       
    start_position_passed++;       
  current_position=move;
}

void p2_move(int target)
{
  if (target==start_position)
    start_position_passed++;
  current_position=target;
}

void readInput() {
  int i;
  int j;
  cin>>number_of_positions;
  for (i=0;i<number_of_positions;i++) {
    for (j=0;j<number_of_positions;j++) {
      cin>>adjacency_matrix[i][j];
    }
  }
  for (i=0;i<number_of_positions;i++) {
    cin>>owner_of_the_position[i];
  }  
  for (i=0;i<number_of_positions;i++) {
    cin>> value_of_the_position[i];
  }
}

int main () {
  start_position=1;
  start_position_passed=0;
  current_position=start_position;
  readInput();
  construct_strategy();
  for (;;) {
    if (owner_of_the_position[current_position-1]==1)
      {
	int move=player_strategy[current_position-1];
	move++;
	cout<<(move)<<endl<<flush;
	p1_move(move);
      }
    if (current_position==start_position && start_position_passed==1)
      {
	exit(0);
      }
    if (owner_of_the_position[current_position-1]==2)
      {
	int ans;
	cin>>ans;
	p2_move(ans);                               
      } 
    if (current_position==start_position && start_position_passed==1)
      {
	exit(0);
      }
  }
  exit(0);
}


