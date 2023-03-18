class BrowserHistory(object):

    def __init__(self, homepage):
        """
        :type homepage: str
        """
        self.history = [homepage]
        self.current_index = 0

    def visit(self, url):
        """
        :type url: str
        :rtype: None
        """
        # Remove forward history when visiting a new URL
        self.history = self.history[:self.current_index + 1]
        self.history.append(url)
        self.current_index += 1

    def back(self, steps):
        """
        :type steps: int
        :rtype: str
        """
        # Move back in history up to 'steps' or to the beginning of history
        self.current_index = max(self.current_index - steps, 0)
        return self.history[self.current_index]

    def forward(self, steps):
        """
        :type steps: int
        :rtype: str
        """
        # Move forward in history up to 'steps' or to the end of history
        self.current_index = min(self.current_index + steps, len(self.history) - 1)
        return self.history[self.current_index]

# Your BrowserHistory object will be instantiated and called as such:
# obj = BrowserHistory(homepage)
# obj.visit(url)
# param_2 = obj.back(steps)
# param_3 = obj.forward(steps)
