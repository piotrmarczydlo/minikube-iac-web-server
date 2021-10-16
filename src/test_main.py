#!/usr/bin/python
import unittest
import main

class MyTest(unittest.TestCase):
    def test_vaule_is_sequoia(self):
        """
        Check is return 'Sequoia' value.
        """
        tree="Sequoia"
        self.assertEqual(main.get_tree()["myFavouriteTree"], tree)

    def test_response_is_json(self):
        """
        Check is return json type.
        """
        self.assertTrue(isinstance(main.get_tree(), dict))

if __name__ == '__main__':
        unittest.main()