#include "calculator.h"

void Calculator::calculate(Symbol symbol) {
	switch(symbol.detection) {
		case NUMBER: {
			data.push(stoi(symbol.raw));
			break;
		}
		case ADD: {
			auto args = pop<2>();
			data.push(args[1] + args[0]);
			break;
		}
		case SUBTRACT: {
			auto args = pop<2>();
			data.push(args[1] - args[0]);
			break;
		}
		case MULTIPLY: {
			auto args = pop<2>();
			data.push(args[1] * args[0]);
			break;
		}
		case DIVIDE: {
			auto args = pop<2>();
			if(args[0] == 0) throw runtime_error("Error: division by 0");
			int result = args[1] / args[0];
			if (result < 0 && args[1] % args[0] != 0) result--;
			data.push(result);
			break;
		}
		case POWER: {
			auto args = pop<2>();
			data.push(std::pow(args[1], args[0]));
			break;
		}
		case MODULO: {
			auto args = pop<2>();
			if(args[0] == 0) throw runtime_error("Error: division by 0");
			int r = args[1] % args[0];
			if(r * args[0] < 0) r += args[0];
			data.push(r);
			break;
		}
		case NEGATE: {
			auto args = pop<1>();
			data.push(-args[0]);
			break;
		}
		default: {
			throw runtime_error("Error: unknown symbol: " + symbol.raw);
		}
	}
}

int Calculator::result() {
	if(data.size() != 1) throw runtime_error("Error: incomplete calculation");
	int r = data.top();
	data.pop();
	clear();
	return r;
}

void Calculator::clear() {
	while(!data.empty()) data.pop();
}