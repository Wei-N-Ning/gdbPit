#include <cstdlib>
#include <vector>

///////////////////////////////////////////

struct Graph {
    std::vector<char> m_name;
    Graph();
    char* name() {
        return &(m_name[0]);
    }
};

Graph::Graph() {
    m_name.resize(8, 0);
    for (auto& c : m_name) {
        c = rand() % 50 + 34;
    }
    m_name[7] = 0;
}

///////////////////////////////////////////

struct Evaluator {
    Graph m_graph;

    Graph* graph() {
        return &m_graph;
    }

    int m_key = 0;

    Evaluator();

    int key() {
        return m_key;
    }
};

Evaluator::Evaluator()
 : m_key(rand()) {
}

struct EvaluatorWrapper {

    Evaluator m_eval;

    const Evaluator* get();
};

const Evaluator* EvaluatorWrapper::get() {
    return &m_eval;
}

///////////////////////////////////////////

struct ID {

    int m_value = 0;

    ID()
     : m_value(rand()) {
    }

    int value();
};

int ID::value() {
    return m_value;
}

///////////////////////////////////////////

struct Process {

    EvaluatorWrapper m_wrapper;
    ID m_id;

    EvaluatorWrapper& evaluator();
    ID& id();
    void run();
};

EvaluatorWrapper& Process::evaluator() {
    return m_wrapper;
}

ID& Process::id() {
    return m_id;
}

void Process::run()  {
    struct Node {
        Node* left = nullptr;
        Node* right = nullptr;
    };
    Node* node(new Node);
    while (node->left) {
        node = node->left;
    }
    delete(node);
}

///////////////////////////////////////////

int main() {
    std::vector<Process> processes(10);
    for (auto& p : processes) {
        p.run();
    }
    return 0;
}