# Daily challenge - March 17th, 2023

## Implement a Trie

<https://leetcode.com/problems/implement-trie-prefix-tree/description/>

nice video description here: <https://www.youtube.com/watch?v=TaROsKvSGjs&t=95s>

```js
/**
* Your Trie object will be instantiated and called as such:
* var obj = new Trie()
* obj.insert(word)
* var param_2 = obj.search(word)
* var param_3 = obj.startsWith(prefix)
*/
```

![Constructor Class Results](es2015-constructor.png)

```js
class TrieNode {
  constructor() {
    this.children = {};
    this.isEndOfWord = false;
  }
}

class Trie {
  constructor() {
    this.root = new TrieNode();
  }
  /** Descend the tree for each character in the new word, creating a node if the
   *  character doesn't exist. Then, mark the end node as such.
   * @param {string} word
   * @return {void}
   */
  insert(word) {
    let currentNode = this.root;
    for (let i = 0; i < word.length; i++) {
      const char = word[i];
      if (!currentNode.children[char]) {
        currentNode.children[char] = new TrieNode();
      }
      currentNode = currentNode.children[char];
    }
    currentNode.isEndOfWord = true;
  }
  /**
   * @param {string} word
   * @return {boolean}
   */
  search(word) {
    let currentNode = this.root;
    for (let i = 0; i < word.length; i++) {
      const char = word[i];
      if (!currentNode.children[char]) {
        return false;
      }
      currentNode = currentNode.children[char];
    }
    return currentNode.isEndOfWord;
  }
  /**
   * @param {string} prefix
   * @return {boolean}
   */
  startsWith(prefix) {
    let currentNode = this.root;
    for (let i = 0; i < prefix.length; i++) {
      const char = prefix[i];
      if (!currentNode.children[char]) {
        return false;
      }
      currentNode = currentNode.children[char];
    }
    return true;
  }
}
```

### Optimized Version

<https://leetcode.com/problems/implement-trie-prefix-tree/submissions/916907418/>

![Optimized results](optimized.png)

```js
class TrieNode {
  constructor() {
    this.children = new Map();
    this.isEndOfWord = false;
  }
}

class Trie {
  constructor() {
    this.root = new TrieNode();
  }
  /** 
   * @param {string} word
   * @return {void}
   */
  insert(word) {
    let currentNode = this.root;
    for (const char of word) {
      currentNode = currentNode.children.get(char) || currentNode.children.set(char, new TrieNode()).get(char);
    }
    currentNode.isEndOfWord = true;
  }
  /**
   * @param {string} word
   * @return {boolean}
   */
  search(word) {
    let currentNode = this.root;
    for (const char of word) {
      currentNode = currentNode.children.get(char);
      if (!currentNode) {
        return false;
      }
    }
    return currentNode.isEndOfWord;
  }
  /**
   * @param {string} prefix
   * @return {boolean}
   */
  startsWith(prefix) {
    let currentNode = this.root;
    for (const char of prefix) {
      currentNode = currentNode.children.get(char);
      if (!currentNode) {
        return false;
      }
    }
    return true;
  }
}

```

### Here is the non-constructor class version

![non-constructor class version](standard.png)

```js
var TrieNode = function () {
  this.children = {};
  this.isEndOfWord = false;
};

var Trie = function () {
  this.root = new TrieNode();
};

/** 
* @param {string} word
* @return {void}
*/
Trie.prototype.insert = function (word) {
  let currentNode = this.root;
  for (let i = 0; i < word.length; i++) {
    const char = word[i];
    if (!currentNode.children[char]) {
      currentNode.children[char] = new TrieNode();
    }
    currentNode = currentNode.children[char];
  }
  currentNode.isEndOfWord = true;
};

/**
* @param {string} word
* @return {boolean}
*/
Trie.prototype.search = function (word) {
  let currentNode = this.root;
  for (let i = 0; i < word.length; i++) {
    const char = word[i];
    if (!currentNode.children[char]) {
      return false;
    }
    currentNode = currentNode.children[char];
  }
  return currentNode.isEndOfWord;
};

/**
* @param {string} prefix
* @return {boolean}
*/
Trie.prototype.startsWith = function (prefix) {
  let currentNode = this.root;
  for (let i = 0; i < prefix.length; i++) {
    const char = prefix[i];
    if (!currentNode.children[char]) {
      return false;
    }
    currentNode = currentNode.children[char];
  }
  return true;
};
```

## Python

<https://leetcode.com/problems/implement-trie-prefix-tree/submissions/916912170/>

```py
class TrieNode:
    def __init__(self):
        self.children = {}
        self.is_end_of_word = False


class Trie:

    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        """
        :type word: str
        :rtype: None
        """
        current_node = self.root
        for char in word:
            if char not in current_node.children:
                current_node.children[char] = TrieNode()
            current_node = current_node.children[char]
        current_node.is_end_of_word = True

    def search(self, word):
        """
        :type word: str
        :rtype: bool
        """
        current_node = self.root
        for char in word:
            if char not in current_node.children:
                return False
            current_node = current_node.children[char]
        return current_node.is_end_of_word

    def startsWith(self, prefix):
        """
        :type prefix: str
        :rtype: bool
        """
        current_node = self.root
        for char in prefix:
            if char not in current_node.children:
                return False
            current_node = current_node.children[char]
        return True


# Your Trie object will be instantiated and called as such:
# obj = Trie()
# obj.insert(word)
# param_2 = obj.search(word)
# param_3 = obj.startsWith(prefix)

```
