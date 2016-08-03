# r_twitter
This script utilizes the Twitter public API to collect data and save it on a CSV file. 
It runs through a list of search phrases, queries.txt, which can be modified based on the users desired interests. 
The language and sentiment is classified. Everything is saved to a CSV and the program ends.


Be sure to change ‘queries.txt’ with your own search phrases and credentialEXAMPLE.r with your own API credentials.

This script uses a sentiment library based on the following two papers:

   Minqing Hu and Bing Liu. "Mining and Summarizing Customer Reviews." 
       Proceedings of the ACM SIGKDD International Conference on Knowledge 
       Discovery and Data Mining (KDD-2004), Aug 22-25, 2004, Seattle, 
       Washington, USA, 


   Bing Liu, Minqing Hu and Junsheng Cheng. "Opinion Observer: Analyzing 
       and Comparing Opinions on the Web." Proceedings of the 14th 
       International World Wide Web conference (WWW-2005), May 10-14, 
       2005, Chiba, Japan.
