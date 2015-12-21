CXX = g++
CXXFLAGS = -c

all: WQUPC

WQUPC: UnionFindMain.o UnionFind.o
	$(CXX) -o UnionFind UnionFindMain.o UnionFind.o
	./WQUPC

UnionFindMain.o: UnionFindMain.cpp UnionFind.h
	$(CXX) $(CXXFLAGS) UnionFindMain.cpp

UnionFind.o: UnionFind.cpp UnionFind.h
	$(CXX) $(CXXFLAGS) UnionFind.cpp

clean:
	rm -rf *.o UnionFind
