/*    kmp: A C++ implementation of the Knuth-Morris-Pratt algorithm
 *
 *    Copyright (C) 2015 University of Southern California and
 *                       Andrew D. Smith
 *
 *    Authors: Andrew D. Smith
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>
#include <cassert>

using std::vector;
using std::string;
using std::cout;
using std::endl;


/*
  This function computes the "prefix" function for the pattern "P"
  which is the same as the sp (not sp') values in Gusfield's book
 */
static void
compute_prefix_function(const string &P, vector<size_t> &sp) {
  const size_t n = P.length();
  sp.resize(n, 0);

  size_t k = 0;
  for (size_t i = 1; i < n; ++i) {

    size_t inner_loops = 0;
    while (k > 0 && P[k] != P[i]) {
      k = sp[k - 1];
      //cout << k <<" ,";
      ++inner_loops;
    }
    if (P[k] == P[i]) ++k;

    sp[i] = k;
  }
}


int main(int argc, const char * const argv[]) {

  if (argc != 3) {
    std::cerr << "usage: " << argv[0] << " <PATTERN> <TEXT>" << endl;
    return EXIT_FAILURE;
  }

  const string P(argv[1]), T(argv[2]);
  const string S = P+T;

  // make sure pattern not bigger than text
  assert(P.length() <= T.length());

  // preprocess the pattern "P"
  vector<size_t> sp;
  vector<char> start_pos;
  compute_prefix_function(S, sp);

  cout << "P:\t" << P << endl;
  cout << "T:\t" << T << endl;
  cout << "S:\t" << S << endl;

  size_t N = S.length()-1;
  size_t p_len = P.length();
  cout<<"Total length(N): "<<N+1<<endl;
  cout<<"Pattern length(P_len): "<<p_len<<endl;
  while (N>=p_len){
      if(sp[N]>=p_len){
        if(S[N]==P[p_len-1] && S[N-p_len+1]==P[0]){
           cout<<"Match at S["<<N<<"] Adjusted: T["<<N-p_len+1<<"]"<<endl;
            //if(N>=2*p_len-11)
                start_pos.push_back(N-p_len+1);
            N=N-p_len;
        }
        else{
            N=N-1;//p_len;
        }
      }
      else{
        N=N-1;
      }
  }
   cout<<"Total matches found: " <<start_pos.size()<<endl;

  return EXIT_SUCCESS;
}
