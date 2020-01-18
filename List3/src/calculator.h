#include <stack>
#include <string>
#include <array>
#include <math.h>
#include <iostream>
#include "defs.h"
#include <stdexcept>

using namespace std;

class Calculator {
	private:
		stack<int> data;

		template<size_t num>
		array<int, num> pop() {
			array<int, num> ret;
			if(data.size() < num) throw runtime_error("Error: not enought data to perform operation");
			for(size_t i = 0; i<num; i++) {
				ret[i] = data.top();
				data.pop();
			}
			return ret;
		}
	public:
		void calculate(Symbol symbol);
		int result();
		void clear();
};