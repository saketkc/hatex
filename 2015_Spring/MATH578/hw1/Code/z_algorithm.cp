/*    z_algorithm: A C++ implementation of Dan Gusfield's Z-algorithm,
 *                 straight from his excellent text.
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

using std::vector;
using std::string;
using std::cout;
using std::endl;

static size_t
match(const string &s, size_t q, const size_t n) {
  for (size_t i = n; std::max(q, i) < s.length() && 
	 (s[i] == s[q]); ++i, ++q);
  return q;
}

int main(int argc, const char * const argv[]) {
  
  if (argc != 2) {
    std::cerr << "must give a string as input!" << endl;
    return EXIT_FAILURE;
  }
  
  const string s(argv[1]);
  
  vector<size_t> Z(s.length());

  string the_case; // A label used to print the case encountered (as
		   // described in Gusfield's book)

  // !!!! If things seem a bit different from the book, it might be that
  // !!!! the C++ code starts indexing strings from 0 instead of 1.
  
  size_t l = 0, r = 0;
 cout << "i"  << "\t" << "li" << "\t" << "ri" << "\t" << "Z[k]" << "\t" << "the_case" << endl;
  for (size_t k = 1; k < s.length(); ++k) {
    if (k >= r) { // Case 1: full comparison
      the_case = "1";
      Z[k] = match(s, 0, k);
      r = k + Z[k];
      l = k;
    }
    else { // Case 2: (we are inside a Z-box)
      const size_t k_prime = k - l;
      const size_t beta_len = r - k;
      if (Z[k_prime] < beta_len) { // Case 2a: stay inside Z-box
	the_case = "2a";
	Z[k] = Z[k_prime];
      }
      else {  // Case 2b: need to match outside the Z-box
	the_case = "2b";
	const size_t q = match(s, r, beta_len);
	Z[k] = q - k;
	r = q;
	l = k;
      }
    }
    cout << k  << "\t" << l + 1 << "\t" << r << "\t" << Z[k] << "\t" << the_case << endl;
  }	
  
  cout << endl 
       << s << endl
       << "i\tZ[i]" << endl
       << "==\t====" << endl;
  for (size_t i = 0; i < Z.size(); ++i)
    cout << i << "\t" << Z[i] << endl;
  
  return EXIT_SUCCESS;
}
