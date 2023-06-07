
var documents = [{
    "id": 0,
    "url": "/404.html",
    "title": "404",
    "body": "404 Page does not exist!Please use the search bar at the top or visit our homepage! "
    }, {
    "id": 1,
    "url": "/about/",
    "title": "About",
    "body": "This is my attempt to document some of the most amazing places that I have been to, the people I have met and things I learnt. "
    }, {
    "id": 2,
    "url": "/about",
    "title": "Mediumish Template for Jekyll",
    "body": "&gt;This website is a place for me to document my personal experiences and share those with my family and friends and you dear stranger ! It started out with my wanting to play around with static website generators but I may use it as my personal blog. Heavily influenced by mediumish-boostrap-jekyll. "
    }, {
    "id": 3,
    "url": "/categories",
    "title": "Categories",
    "body": ""
    }, {
    "id": 4,
    "url": "/index.html",
    "title": "Home",
    "body": "{% if paginator. page == 1 %}       Featured:       {% for post in site. posts %}    {% if post. featured == true %}      {% include featuredbox. html %}    {% endif %}  {% endfor %}  {% endif %}       All Other Stories:     {% include gallery. html %}1{% include pagination. html %}"
    }, {
    "id": 5,
    "url": "/page/2/index.html",
    "title": " - page 2",
    "body": "{% if paginator. page == 1 %}       Featured:       {% for post in site. posts %}    {% if post. featured == true %}      {% include featuredbox. html %}    {% endif %}  {% endfor %}  {% endif %}       All Other Stories:     {% include gallery. html %}1{% include pagination. html %}"
    }, {
    "id": 6,
    "url": "/page/3/index.html",
    "title": " - page 3",
    "body": "{% if paginator. page == 1 %}       Featured:       {% for post in site. posts %}    {% if post. featured == true %}      {% include featuredbox. html %}    {% endif %}  {% endfor %}  {% endif %}       All Other Stories:     {% include gallery. html %}1{% include pagination. html %}"
    }, {
    "id": 7,
    "url": "/robots.txt",
    "title": "",
    "body": "      Sitemap: {{ “sitemap. xml”   absolute_url }}   "
    }, {
    "id": 8,
    "url": "/2023/06/trails-of-washington-a-hikers-guide.html",
    "title": "Sunset Hiking Bandera with Phil",
    "body": "2023/06/05 - Yesterday, I had the incredible opportunity to hike up Bandera Mountain in Washington State. It had been something that I had wanted to do for a while now and I’m so glad I got to share this experience with my friend Phil. The sunset hike was breathtaking–literally. We made it up just in time to see the sun sink below the tree line. As we admired the incredible view from the top of the mountain, I couldn’t help but feel a sense of satisfaction for having made it to the summit. It was definitely an experience I will never forget.   Bandera mountain sunset hike with Phil  Bandera mountain sunset hike with Phil  Bandera mountain sunset hike with Phil  Bandera mountain sunset hike with Phil  Bandera mountain sunset hike with Phil"
    }, {
    "id": 9,
    "url": "/2023/05/lakeshore-hiking-adventure-memorial-day-getaway.html",
    "title": "Lakeshore Hiking Adventure: Memorial Day Getaway",
    "body": "2023/05/27 - Memorial Day weekend is fast approaching and I’m excited to take advantage of it by exploring the Lakeshore Trail near Lake Chelan. For 3 days and 2 nights I’ll be hiking the trail to take in the beauty of the area’s rolling hills, shady trees, and the magnificent lake! This part of Washington State is a great place to take a holiday with its abundance of outdoor activities. I’m looking forward to the fresh air while being surrounded by nature. During this hiking trip I’m sure I will come across some breathtaking views. There’s nothing like getting off the beaten path and discovering the beauty that comes from something as simple as a hike in the woods. I’m sure that my Memorial Day weekend will be filled with plenty of adventure and beautiful scenery.   LakeShore trail 2023    LakeShore trail 2023  LakeShore trail 2023  LakeShore trail 2023"
    }, {
    "id": 10,
    "url": "/2023/03/snowshoe-kendal-peak-lake-wa-state.html",
    "title": "Kendal Peak Lake Snowshoe",
    "body": "2023/03/16 - Kendal Peak in Washington State is an iconic and breathtaking winter adventure spot. With stunning views of the lake below and majestic snow-covered peaks in the distance, a day spent at Kendal Peak is the perfect escape. Take in the majestic beauty of the mountains on a snowshoe trek through the untouched powder of this pristine landscape. Explore the unspoiled wilderness and spend the day playing in the snow, breathing the crisp winter air and taking in the scenery. With its secluded location and miles of untouched terrain, Kendal Peak offers the perfect winter escape for skiers and snowshoers alike. "
    }, {
    "id": 11,
    "url": "/2023/03/Middle-fork-trail.html",
    "title": "Middle Fork Trail",
    "body": "2023/03/05 - The Middle Fork Trail is a beautiful hiking option in Washington State, offering stunning views of mountains, rivers, and snow-capped peaks. This trail is renowned for its natural beauty, and offers plenty of opportunities for peaceful exploration. With lush meadows, craggy cliffs, and old-growth forests, the Middle Fork Trail is a great choice for those looking to explore the outdoors. With access to areas of the mountain that attract a range of wildlife, the Middle Fork Trail provides excellent wildlife viewing opportunities, particularly in the wintertime. The stunning river views, stunning mountain vistas, and exciting wildlife encounters make this a great choice for anyone looking to explore the beauty of Washington State. "
    }, {
    "id": 12,
    "url": "/2023/01/washingtons-heather-lake-hiking-trail.html",
    "title": "Washington's Heather Lake Hiking Trail.",
    "body": "2023/01/22 - I recently had the chance to go to Heather Lake Trail in Washington State. It was a beautiful day on January 22, 2023, with some scattered sunshine throughout the morning hours. The weather was perfect for a moderate 1. 8 mile hike from the trailhead to the 10 acre lake. It was a stunning view, with the lake’s water reflecting the sun and the surrounding snow-covered peaks. The trail was fairly easy, but with some steeper sections in various parts of the hike. I found it to be a great day as I took in the scenery and enjoyed some peaceful moments away from the hustle and bustle of daily life.   Heather lake trail  Heather lake trail  Heather lake trail  Heather lake trail  Heather lake trail"
    }, {
    "id": 13,
    "url": "/2022/04/wildlife-adventure-in-costa-rica.html",
    "title": "Wildlife Adventure in Costa Rica.",
    "body": "2022/04/11 - Traveling to Costa Rica was a dream come true! Our trip included a boat ride down the Rio Frio and a visit to the Cano Negro Wildlife Refuge. We saw hundreds of beautiful birds, sloths, monkeys and other animals living in their natural habitats. It was an unforgettable experience watching the wildlife from the boat. We even encountered a rare three-toed sloth near the shore! It was a great opportunity to experience some of the country’s most incredible wildlife. Costa Rica is truly a paradise for bird and animal lovers alike.   costa rica0076. jpg  _DSC0916. jpg  _DSC0971. jpg  _DSC0885. jpg  _DSC0492. jpg"
    }, {
    "id": 14,
    "url": "/2022/04/costa-rica-trip.html",
    "title": "Costa Rica - part deux",
    "body": "2022/04/10 -  I fell in love with Costa Rica the first time I went there. I was my first trip outside of the US and I was amazed by the natural beauty and kindness of the people.  Our itinerary / high level plan Local services we used What you will need to bring with you Driving     San Jose to Arenal :   Arenal to Monte Verde :   Monte Verde to Jaco   Jaco to San Jose   Our itinerary / high level plan:       Date   Activity   Driving   Stay   Notes         1   Fly into San Jose   -   Melrost Airport B&amp;B           2   Drive to Arenal   3-4 hrs   Arenal - Volcano Lodge, Hotel &amp; Thermal Experience   Pick up car Vamos was great       3   Canoa Negro Float    Hotel Pickup   Arenal   One of the best ways to see wild life       4   Hanging Bridge, Arenal 1968   None   Arenal   1968 trail was amazing       5   Drive to Monte Verde   3-4 hours   Hotel Claro de Luna   best roads are Route 142 to Tilaran, then Route 145 to 606. This drive takes about 3. 5-4 hours (from La Fortuna) and is along a mix of paved and dirt roads       6   In Monte Verde   None   Monte Verde   https://reservacuricancha. com/ You can also give us a call at: (506) 2645-6915 / (506) 8448-8283 Starts at 6:00.        7   Drive to Jaco       Hotel Club del Mar Oceanfront   Hotel was nice. Beach town for locals.        8   Drive to San Jose       Marriott Hotel Hacienda Belen   Beautiful hotel. Great dinner and some tennis in sandals       9   Fly to Seattle       Marriott Hotel       Local services we used Car rental (Vamos). They dropped off and picked up the car from the hotels we stayed in for a very reasonable price ($20ish) Get a SIM card with Kolbi. great coverageWhat you will need to bring with you Head lamps Baby wipes ? Small hand sanitizer(s) Diarreah pills Arnica cream or gel - in case of bumps, bruises, etc - it works wonders.  Ponchos / small umbrella Money belt Sony camera + extra batteries + charger Water shoes for beach and ocean Spanish language book / dictionary / translation app Plastic bags, zip log bags Several color copies of passport Long socks , up to knees TP roll ? Take cash $400 or so each Chafing cream Bandana Small first aid kit Summit packs (2?) Travel insurance for United flightDriving Driving in CR is very peaceful. The traffic is well behaved, especially once you are out of the capital San Jose. We planned our rentals in such a way that Vamos delivered the car to us on our 1st day of the rental and picked it up on the last day from a different location. This is the way to do it instead of figuring out a way to get to their office in SJ on pickup and return. San Jose to Arenal :: San Jose to Arenal: If you are coming from San Jose, it should take you no more than 3-4 hours to get to La Fortuna, Costa Rica. Traveling west on Route 1 will take you to San Ramon where you will then take Route 702 to La Fortuna. The total driving distance from La Fortuna/Arenal to San Jose is 139 km (86 miles). Although it doesn’t sound like a long distance, the winding roads will slow you down so be sure to plan accordingly. Arenal to Monte Verde :: ￼ Monte Verde to Jaco: ￼ Jaco to San Jose: ￼ "
    }, {
    "id": 15,
    "url": "/2021/08/wildlife-adventure-in-kenai-peninsula.html",
    "title": "Wildlife Adventure in Kenai Peninsula.",
    "body": "2021/08/14 - My trip to Alaska was definitely one of the most incredible experiences of my life! I traveled across the Kenai peninsula and encountered wildlife I could only dream of seeing. I got to observe puffins gracefully flying across the water, bald eagles soaring through the sky, and sea otters lounging on the beach. I will never forget the wonder of these wild places and the memories I made while I was there.           "
    }, {
    "id": 16,
    "url": "/2021/08/whale-breach.html",
    "title": "Anatomy of a picture",
    "body": "2021/08/14 - This was one of the hardest (and luckiest) picture I have taken in a very long time. There is a lot that goes on behind taking a picture like this one. At the minimum :  you to be at the right place (on a crowded whale watching boat deck) and at the right time (✔).  your camera settings should be correct (in this case fast shutter speed and burst mode) you need to be pointing in the right direction. This was the trickiest part since you could not really predict where the whale would breach. They seem to love diving deep in the ocean and surfacing at a different part.  assuming you have all the above ready to go, you have to make sure that you click on the trigger the moment you see the whale breaching. Too soon and your camera buffer may fill up (you made sure you are using a fast camera card right ? 😄), too late and you miss key moments. All these things came together and I was able to capture this wonderful beast, not once but twice. The 2nd time was further away and so I didnt get as good shots (though I would have been happy with just those by themselves too. )   Here is a picture of a typical whale watching boat"
    }, {
    "id": 17,
    "url": "/2021/08/kenai-fjords-national-park.html",
    "title": "Kenai Fjords National Park Alaska",
    "body": "2021/08/14 -  You know you are in for a treat when you go whale watching in the Kenai Fjords national parks in Alaska. This was my second time in Seward and I went with the trusted Major Marines Tours !. I think we picked the 6 or 7 hour version (the longer the better I feel) Some of the highlights of the trip were :  Seeing Humpback whales breaching and playing with each other Seeing massive glaciers up close Puffins, otters, bald eagles Amazing drinks they make off the freshly harvested ice from the glacier  I believe I can fly!"
    }, {
    "id": 18,
    "url": "/2021/08/glacier-cruise-in-seward-alaska.html",
    "title": "Glacier Cruise in Seward, Alaska.",
    "body": "2021/08/14 - I had the luck to travel to Alaska recently, and it was one of the most breathtaking experiences I have ever had. I started my trip in the beautiful city of Seward, where I took a day-long cruise via a glacier. The views were indescribably beautiful, and I drank in all of the gorgeous, glistening blue hues of the glacier and the shore. Even though Alaska was colder than I had anticipated, it was worth it to see the incredible beauty of nature that this place has to offer.           "
    }, {
    "id": 19,
    "url": "/2021/08/alaskan-whale-watching-adventure.html",
    "title": "Alaskan Whale Watching Adventure",
    "body": "2021/08/14 - One of the most magical experiences available in Seward, Alaska is whale watching. With the stunning views of the sea, mountains, and glaciers, whale watching here is a truly majestic experience. If you’re lucky, you just might spot a whale breach! Seeing a whale at full size as it pokes its enormous head out of the water is a sight that will stay with you forever. Seward’s whale watching is an experience that simply can’t be missed!           "
    }, {
    "id": 20,
    "url": "/2019/03/skyline-lake-snowshoe-washington-state.html",
    "title": "Skyline Lake Snowshoe",
    "body": "2019/03/09 - Skyline lake snowshoe is an amazing snowshoe by Stevens Pass East. It has incredible views, a frozen lake (depending on time of the year) and a beautiful rock garden at the top. Make sure to get there early enough since parking can be limited at the Stevens Pass parking lot (just east of the pass). See www. wta. org/go-hiking/hikes/skyline-lake-snowshoe for more details.             "
    }, {
    "id": 21,
    "url": "/2018/09/jenny-lake-morning-hike-mountain-bliss.html",
    "title": "Jenny Lake Morning Hike: Mountain Bliss",
    "body": "2018/09/26 - My morning started early, with the sun just peeking over Grand Teton in the distance. There’s nothing quite like a morning hike around Jenny Lake. I was excited to start my journey along the lakeside, surrounded by the picturesque mountain range. As I rounded the lake, I was in awe of the crystal clear water. Taking a short break on a rock along the shoreline I took in the stunning beauty of the lake and its surroundings. I couldn’t think of a better way to start my morning.           "
    }, {
    "id": 22,
    "url": "/2018/09/grand-teton-national-park-adventure.html",
    "title": "Grand Teton National Park Adventure",
    "body": "2018/09/25 - Visiting Grand Teton National Park was one of the most grand experiences I’ve ever had. More than a million acres of breathtaking scenery and a wide variety of wildlife present a unique experience. The mountains tower in the sky and amazing wildlife including elk, bison, moose and more can be seen without a lengthy hike. Grand Teton is a beloved treasure in the American West and I’m grateful for the opportunity to explore its vast beauty.           "
    }, {
    "id": 23,
    "url": "/2018/09/yellowstones-grand-canyon.html",
    "title": "Yellowstone's Grand Canyon.",
    "body": "2018/09/24 - As I hiked along the South Rim of the Grand Canyon of Yellowstone National Park, I felt overwhelmed with the view before me. The sheer eagle of the canyon walls, the river snaking through, and the imprint of the wind and the water shaped the canyon over time all astounded me. The intensity of the colors, from the yellow and red of the rocks to the deep greens and blues of the river, created an incredible experience I will never forget.           "
    }, {
    "id": 24,
    "url": "/2018/09/vibrant-colors-of-grand-prismatic-spring.html",
    "title": "Vibrant Colors of Grand Prismatic Spring",
    "body": "2018/09/23 - Visiting Grand Prismatic Spring in Yellowstone National Park was one of the most memorable experiences of my life! With its vibrant colors of blue, yellow, purple, and green, the spring is simply breathtaking. What sets this spring apart from others is the multi-colored rings of vibrant microorganisms that decorate the surface. It was one of the few places that literally took my breath away, and I was mesmerized by its beauty for hours.           "
    }, {
    "id": 25,
    "url": "/2018/09/bison-roaming-yellowstones-vast-landscapes.html",
    "title": "Bison Roaming Yellowstone's Vast Landscapes",
    "body": "2018/09/23 - I recently visited Yellowstone National Park and experienced its unbelievable beauty for myself. The view of the vibrant colors of nature and the presence of bison grazing made me feel a sense of being in a different world. The combination of the park’s serene atmosphere and its tons of opportunities for activities such as sightseeing, hiking, and fishing truly made my vacation one to remember!           "
    }, {
    "id": 26,
    "url": "/2018/09/yellowstone-highlights.html",
    "title": "Yellowstone Highlights",
    "body": "2018/09/22 -  We drove from Seattle to Yellowstone and entered from the northern entrance where we saw the Mammoth Hot Springs and a lot of wild life. Some of the highlights of the day were :: Rivers of Yellowstone: This one was an unexpected and pleasant surprise for us. We had no idea about the beauty and serenity of the river system in Yellowstone. I could have spent a few days taking pictures and drawing them if I could. Something to do on a longer visit some day 😄   Im not into fishing but there is something very peaceful in watching these guys fly fishing  The rivers had this wonderful foreground to the great plains and majestic mountains in the distance. Mammoth Hot Springs:   Mammoth Hot Springs  Beautiful and colorful patterns  Beautiful and colorful patternsWild life:   wild life  Goat 🐐  Some kind of gazelle ?Bon Fire !!: This was on our way back to the AirBnb. Remind me to link the lovely place we stayed at. We were heading back when we saw these huge flames in the distance. As we drove closer we saw a huge communal bon fire which was about 2-3 storey high. There were a lot of people around it, having a great time. I wish I had had my better camera / lens, but these are the pictures I captured from a distance. It was one of those sights where you had to stop by the side of the road and take some pictures 😄   Huge flames  Huge flames"
    }, {
    "id": 27,
    "url": "/2018/09/bison-trail-hike-in-yellowstone.html",
    "title": "Bison Trail Hike in Yellowstone",
    "body": "2018/09/22 - Hellroaring Hike in the Yellowstone National Park is one of the most popular trails for adventurous hikers. The five-mile trail crosses through a variety of landscapes, which include a large meadow and a waterfall. It’s also a popular location for spotting the park’s wild bison. The trail is relatively easy so it’s suitable for hikers of all fitness levels. If you’re looking for an exciting, outdoor experience, a Hellroaring Hike should be at the top of your list.           "
    }, {
    "id": 28,
    "url": "/2017/10/fall-hike-to-artist-point.html",
    "title": "Fall Hike to Artist Point",
    "body": "2017/10/08 - Hiking up to Artist Point is a must-do on any visit to the Pacific Northwest. The Chain Lake Trail is one of the best in the area, with breathtaking views of the snow-capped mountain ridges. Fall is especially beautiful, as the trees are bursting with colorful hues of red, orange, and yellow. Along the trail, keep your eyes peeled for ptarmigan, who make their home among the rocky ridgelines. A hike to Artist Point is definitely a highlight of any experience in Washington!   _MG_3690  _MG_3939  _MG_3942  _MG_3934  IMG_3870"
    }, {
    "id": 29,
    "url": "/2017/08/1st-backpacking-with-baloo.html",
    "title": "My first solo backpacking with Baloo",
    "body": "2017/08/27 -  This was my first “solo” backpacking adventure. I decided to go on a long 4 day hike in the North Cascades and I picked a tough scenic one - North Fork Sauk Trail Some of the things that made this very challenging were :  My first solo trip It was about 30 miles, in high country and it was a hot summer week.  I had no idea that Baloo gets so hot and needs a lot of water himself.   Baloo resting after another long day of hiking in the hot sun  Mountains bathing in alipine glow!  Looking out into the valley  Beautiful sunset  Bear grass"
    }, {
    "id": 30,
    "url": "/2017/06/mt-dickerman-winter-route.html",
    "title": "Mt Dickerman Winter Route",
    "body": "2017/06/05 -  Mt Dickerman is one of the premier hikes in the Pacific North West. It is a beast of a climb but the rewards are amazing. I decided to climb via the winter route for a change. The winter route, mainly follows the summer route but towards the top instead of taking switch-backs you go straight up as the crow flies. This hike is not to be taken lightly, even in the best of situations and especially not in winter conditions.   Baloo saying - lets go hike already !Not too shabby along the way too   Blue bird day  My buddy Eric hiking up  Final Ascent  Beautiful but deadly cornices  Crowded at the top ?At the very top   Mountains as far as you can see  Winter makes everything extra magical  Doggie paradise  Snow capped mountains"
    }, {
    "id": 31,
    "url": "/2017/05/snowy-hike-to-miller-peak.html",
    "title": "Snowy Hike to Miller Peak",
    "body": "2017/05/27 - I recently hiked Miller Peak in the Teanaway area and it was an amazing experience! My trusty pup Baloo and I hiked the peak which was carpeted with snow at the top. Although the climb and descent was a bit rough, I was rewarded with some breathtaking and beautiful views. It was the perfect way to start the new year - I would definitely recommend it to anyone looking to explore the area!   _DSC6956  _DSC6991  _DSC7029  _DSC7034  _DSC7040"
    }, {
    "id": 32,
    "url": "/2017/01/winter-hike-with-baloo-and-phil.html",
    "title": "Winter Hike with Baloo and Phil",
    "body": "2017/01/02 - My 2017 winter hike to Lake Serene was definitely one of the most memorable hikes I have ever done! The snow was deep and pristine, the mountains majestic, and my hiking buddies were Baloo (my trusty pup) and my friend Phil. It felt great to be out in the fresh winter air and take in the stunning scenery and do something adventurous. Every inch of that trail was beautiful and I can’t wait to go back soon!   _DSC5799  _DSC5859  _DSC5852  _DSC5851  _DSC5843"
    }, {
    "id": 33,
    "url": "/2014/12/snowshoeing-adventure-at-mt-rainier.html",
    "title": "Snowshoeing Adventure at Mt. Rainier",
    "body": "2014/12/14 - On December 14th, 2014, I decided to make a special trip to Mt Rainier. I wanted to experience all of its unique winter offerings, so I set up a morning at the base and hopped on a gondola with my snowshoes for higher altitude. After disembarking, I grabbed a map and started exploring the trails. I trekked through the fresh snow and explored nearby ridge lines while snowshoeing and hiking in the breathtaking scenery of the mountain. It was simply magical. The sound of the snow crunching beneath my feet as I forged a path through the dense brush and wind-swept trails was truly unforgettable. I can’t wait to make the trek again and explore Mt Rainier in the years to come.   _MG_6835  _MG_6846  _MG_6852  _MG_6854  _MG_6858"
    }, {
    "id": 34,
    "url": "/2013/10/journey-to-everests-base-camp.html",
    "title": "Journey to Everest's Base Camp",
    "body": "2013/10/24 - Exploring the majestic, snow-capped mountains around Everest Base Camp in Nepal was one of the most unforgettable experiences of my life. The mountain village of Gorak Shep, tucked away between two mountain peaks, was especially astonishing. The locals were incredibly hospitable and the views were breathtaking. I would highly recommend anyone heading to Nepal to make the extra effort and take the trek to Everest Base Camp - it is an experience you will never forget!   Untitled_Panorama4  _MG_2426_7_8  _MG_2417_8_9  _MG_2342_3_4  _MG_2411_2_3"
    }, {
    "id": 35,
    "url": "/2013/10/high-altitude-adventure-everest-base-camp.html",
    "title": "High Altitude Adventure: Everest Base Camp",
    "body": "2013/10/22 - Trekkers from all over the world flock to Everest Base Camp - the iconic trail to the world’s highest mountain. Trekkers are rewarded with a once in a lifetime experience; breathtaking Panoramic Views of snow-covered Mountains surrounding them. This mesmerizing, fluffy blanket of snow stretches across the horizon in every direction, changing in intensity depending on the time of day. Trekkers can feel on top of the world in this mesmerizing landscape of snowy mountains!   Untitled_Panorama2a  Untitled_Panorama1  _MG_2243  _MG_2287_8_9  _MG_2269_70_71"
    }, {
    "id": 36,
    "url": "/2013/10/yak-trekking-to-everest-base-camp.html",
    "title": "Yak Trekking to Everest Base Camp",
    "body": "2013/10/21 - Nothing can beat the feeling of reaching the towering peak of Everest Base Camp as the sun slowly rises in the horizon. It was the perfect time to snap a photograph of the snow covered mountains with our yak carrying the heavy hiking gear. With each step, we felt the elevation change and quickly reached 13,800 feet above sea level. It marked the highest we had ever climbed and it was a magnificently rewarding experience.   _MG_2158  _MG_2077_8_9  _MG_2113_4_5  _MG_2155_6_7  _MG_2086_7_8"
    }, {
    "id": 37,
    "url": "/2013/10/hiking-to-tengboche-in-nepal.html",
    "title": "Hiking to Tengboche in Nepal.",
    "body": "2013/10/20 - My experience hiking to Everest Base Camp was one of the most amazing experiences of my life. From starting my journey in Nepal to the breathtaking views of Tengboche, every moment was breathtaking. The hike was never ending and challenging, but the feeling of arriving at my destination made it all worth it in the end. Although it was a tough adventure to take on, I would do it again in a heartbeat!   EBC Tengboche 10-20-401_2_3  EBC Tengboche 10-20-487  EBC Tengboche 10-20-234  EBC Tengboche 10-20-98  EBC Tengboche 10-20-453"
    }, {
    "id": 38,
    "url": "/2013/10/journey-to-nepals-majestic-mountains.html",
    "title": "Journey to Nepal's Majestic Mountains",
    "body": "2013/10/19 - Hiking to Everest Base Camp in Nepal was an adventure unlike any other. Every day presented a new vista of beautiful mountains like Amadablam, and it felt like being in a world where beautiful mountains were everywhere you looked. The journey to reach Everest Base Camp was challenging, but the breathtaking views of nature more than made up for it.   Everest Base Camp - Day 2 -690  Everest Base Camp - Day 2 -1  Everest Base Camp - Day 2 -34  Everest Base Camp - Day 2 -38  Everest Base Camp - Day 2 -30"
    }, {
    "id": 39,
    "url": "/2013/10/hiking-to-everest-base-camp-nepal.html",
    "title": "Hiking to Everest Base Camp, Nepal.",
    "body": "2013/10/18 - No trip to Nepal is complete without experiencing the journey to Everest Base Camp! The adventure began as soon as I walked through the entrance of Lukla Airport, the start of the hike. The views were breathtaking and the adrenaline was kicking in; I was ready to make my way to the base camp! The trek was long but the views along the way made it worth it. As I reached the final destination, I was in complete awe of the view in front of me. It was unlike any other place I have ever been before.   Everest Base Camp - Day 1 -39  Everest Base Camp - Day 1 -48  Everest Base Camp - Day 1 -40  Everest Base Camp - Day 1 -51  Everest Base Camp - Day 1 -88"
    }];

var idx = lunr(function () {
    this.ref('id')
    this.field('title')
    this.field('body')

    documents.forEach(function (doc) {
        this.add(doc)
    }, this)
});
function lunr_search(term) {
    document.getElementById('lunrsearchresults').innerHTML = '<ul></ul>';
    if(term) {
        document.getElementById('lunrsearchresults').innerHTML = "<p>Search results for '" + term + "'</p>" + document.getElementById('lunrsearchresults').innerHTML;
        //put results on the screen.
        var results = idx.search(term);
        if(results.length>0){
            //console.log(idx.search(term));
            //if results
            for (var i = 0; i < results.length; i++) {
                // more statements
                var ref = results[i]['ref'];
                var url = documents[ref]['url'];
                var title = documents[ref]['title'];
                var body = documents[ref]['body'].substring(0,160)+'...';
                document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML + "<li class='lunrsearchresult'><a href='" + url + "'><span class='title'>" + title + "</span><br /><span class='body'>"+ body +"</span><br /><span class='url'>"+ url +"</span></a></li>";
            }
        } else {
            document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = "<li class='lunrsearchresult'>No results found...</li>";
        }
    }
    return false;
}

function lunr_search(term) {
    $('#lunrsearchresults').show( 400 );
    $( "body" ).addClass( "modal-open" );
    
    document.getElementById('lunrsearchresults').innerHTML = '<div id="resultsmodal" class="modal fade show d-block"  tabindex="-1" role="dialog" aria-labelledby="resultsmodal"> <div class="modal-dialog shadow-lg" role="document"> <div class="modal-content"> <div class="modal-header" id="modtit"> <button type="button" class="close" id="btnx" data-dismiss="modal" aria-label="Close"> &times; </button> </div> <div class="modal-body"> <ul class="mb-0"> </ul>    </div> <div class="modal-footer"><button id="btnx" type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button></div></div> </div></div>';
    if(term) {
        document.getElementById('modtit').innerHTML = "<h5 class='modal-title'>Search results for '" + term + "'</h5>" + document.getElementById('modtit').innerHTML;
        //put results on the screen.
        var results = idx.search(term);
        if(results.length>0){
            //console.log(idx.search(term));
            //if results
            for (var i = 0; i < results.length; i++) {
                // more statements
                var ref = results[i]['ref'];
                var url = documents[ref]['url'];
                var title = documents[ref]['title'];
                var body = documents[ref]['body'].substring(0,160)+'...';
                document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML + "<li class='lunrsearchresult'><a href='" + url + "'><span class='title'>" + title + "</span><br /><small><span class='body'>"+ body +"</span><br /><span class='url'>"+ url +"</span></small></a></li>";
            }
        } else {
            document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = "<li class='lunrsearchresult'>Sorry, no results found. Close & try a different search!</li>";
        }
    }
    return false;
}
    
$(function() {
    $("#lunrsearchresults").on('click', '#btnx', function () {
        $('#lunrsearchresults').hide( 5 );
        $( "body" ).removeClass( "modal-open" );
    });
});