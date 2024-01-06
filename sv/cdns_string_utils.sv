/*
 //------------------------------------------------------------
 //   Copyright 2014-2015 Cadence Design
 //   All Rights Reserved Worldwide
 //
 //   Licensed under the Apache License, Version 2.0 (the
 //   "License"); you may not use this file except in
 //   compliance with the License.  You may obtain a copy of
 //   the License at
 //
 //       http://www.apache.org/licenses/LICENSE-2.0
 //
 //   Unless required by applicable law or agreed to in
 //   writing, software distributed under the License is
 //   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 //   CONDITIONS OF ANY KIND, either express or implied.  See
 //   the License for the specific language governing
 //   permissions and limitations under the License.
 //------------------------------------------------------------

 mailto: uwes@cadence.com

 helper package to provide addon string handling functions

 - string str_join(string del,string s[$])
 -

 */

package cdns_string_utils;
	
	// joins the queue of strings ~s~ using the delimiter ~del~ and returns
	// resulting string
	function automatic string str_join(string del=",", string s[$]);
		string r[$];
		foreach(s[idx]) begin
			r.push_back(s[idx]); r.push_back(del);
		end
		if(r.size())
			void'(r.pop_back());

		str_join={>>{r}};
	endfunction
endpackage
