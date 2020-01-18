#pragma once
#include <string>

enum Detection {
	SKIP,
	NUMBER,
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	POWER,
	MODULO,
	NEGATE
};

struct Symbol {
	Detection detection;
	std::string raw;
};