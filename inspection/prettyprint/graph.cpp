#include <vector>

using namespace std;

class Parameter {
public:
    Parameter(int v)
      : m_value(v) {
    }
private:
    int m_value = 0;
};

class Node {
public:
    Node(int numParams) {
        for (int i = 0; i < numParams; ++i) {
            m_params.emplace_back(new Parameter(i));
        }
    }
    ~Node() {
        for (auto param : m_params) {
            delete(param);
        }
    }
private:
    vector<Parameter *> m_params;
};

namespace core { namespace graph {
class Graph {
public:
    Graph(int numNodes) {
        for (int i = 0; i < numNodes; ++i) {
            m_nodes.emplace_back(new Node(i));
        }
    }
    ~Graph() {
        for (auto node : m_nodes) {
            delete(node);
        }
    }
private:
    vector<Node *> m_nodes;
};

} // namespace graph
} // namespace core

void processGraph(core::graph::Graph& graph) {
    ;
}

class Graph {
    vector<void *> m_data;
};

int main() {
    core::graph::Graph g(3);
    Graph phony;
    processGraph(g);
    return 0;
}