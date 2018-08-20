#include <iostream>
#include <numeric>
#include <vector>
#include <cassert>

namespace core {

using namespace std;

class Parameter {
public:
    Parameter(int v)
      : m_value(v) {
    }
    int get() {
        return m_value;
    }
private:
    int m_value = 0;

    // create some noises here
    int m_creationTime = 101;
};

// create a shady side effect
void mutate(Parameter*& param) {
    int value = param->get();

    // when the parameter's value is 38, nullify this parameter
    if (value % 30 == 8) {
        delete(param);
        param = nullptr;
    }
}

class Node {
public:
    Node(int numParams) {
        assert(numParams > 0);
        for (int i = 0; i < numParams; ++i) {
            m_params.emplace_back(new Parameter(i));
        }
    }
    ~Node() {
        for (auto param : m_params) {
            if (param) {
                delete(param);
            }
        }
    }
    void setFirst(int value) {
        if (m_params[0]) {
            delete(m_params[0]);
        }
        m_params[0] = new Parameter(value);
        mutate(m_params[0]);
    }
    int compute() {
        return std::accumulate(
            m_params.begin(),
            m_params.end(),
            m_params[0]->get(),
            [](int init, Parameter* oneParam) -> int {
                return init + oneParam->get();
            }
        );
    }
private:
    vector<Parameter *> m_params;

    // create some noises here
    int m_numVariants = 10;
    int m_numDimensions = 3;
    char m_nameCStr[32];
};

namespace graph {

class Graph {
public:
    Graph(int numNodes, int argument)
      : m_argument(argument) {
        assert(numNodes > 0);
        for (int i = 0; i < numNodes; ++i) {
            m_nodes.emplace_back(new Node(i + 1));
        }
    }
    ~Graph() {
        for (auto node : m_nodes) {
            delete(node);
        }
    }
    int compute() {
        int arg = m_argument;
        for (Node* node : m_nodes) {
            node->setFirst(arg);
            arg = node->compute();
        }
        return arg;
    }
private:
    vector<Node *> m_nodes;
    int m_argument;

    // create some noises here
    char m_nameCStr[32];
};

} // namespace graph

} // namespace core

void processGraph(core::graph::Graph& graph) {
    graph.compute();
}

class Graph {
    std::vector<void *> m_nodes;
};

int main() {
    core::graph::Graph g(3, 0x13);
    Graph phony;
    phony = Graph();
    processGraph(g);
    return 0;
}