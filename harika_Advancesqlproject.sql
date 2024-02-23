use ig_clone;

/*1. How many times does the average user post? */

Select * from users;
select * from photos;
select count(*) from users;
select count(*) from photos;


select Round((select count(*) from photos)/(select count(*) from users),2)Avg_users_post;

/* Insight:- Here from the output,we can observe that the average user post is 2.57 */


/*2. Find the top 5 most used hashtags */


with cte_Rank_tagname
 as (
select tag_id,tag_name,count(*)Top_5_most from tags t inner join photo_tags pt 
on t.id=pt.tag_id
group by tag_id,tag_name
order by Top_5_most desc limit 5)
select cte_Rank_tagname.tag_id,cte_Rank_tagname.tag_name,Top_5_most,
rank() over( order by Top_5_most desc) Rank_for_Top_most from cte_Rank_tagname;


/* Insight:-From the output,we can observe that Top 5 Used hastags are 
smile,beach,party,fun,concert. */

/*3. Find users who have liked every single photo on the site */


select id,username,count(*)user_liked_every_single_photo from users u inner join likes l
on u.id=l.user_id
group by username
having user_liked_every_single_photo=(select count(*) from photos);

/* Insight:-There are 13 users who have liked every single photo(257 photos).



/*4. Retrieve a list of users along with their usernames and 
the rank of their account creation, 
ordered by the creation date in ascending order. */

select id,username,created_at,
Rank() over (order by created_at asc)Rank_ofCreation_date from users
order by Rank_ofCreation_date asc;

/* Insight:-According to Rank_ofCreation_date Rank 1 is Darby_Herzog and 
Rank 100 is Justina.Gaylord27.


/* 5.List the comments made on photos with their comment texts,
 photo URLs, and usernames of users who posted the comments.
 Include the comment count for each photo */


with cte as (
select username,comment_text,image_url from users u inner join photos p 
on u.id=p.user_id inner join comments c on  c.photo_id=p.id)
select comment_text,image_url,username,
count(comment_text) over (partition by image_url)Comment_count_for_each_photo from users u inner join photos p 
on u.id=p.user_id inner join comments c on  c.photo_id=p.id
order by Comment_count_for_each_photo desc;

/* Insight:- We can observe that most of comments for Image "https://fred.com" 
i.e., count  is 39
and least comments for  "http://ora.net" i.e., count is 21

/* 6.For each tag, show the tag name and the number of photos associated with that tag.
 Rank the tags by the number of photos in descending order. */

with cte as (  
select distinct tag_name,count(photo_id) over (partition by tag_name)Num_of_photos
 from tags t inner join photo_tags pt on t.id=pt.tag_id)
 select tag_name,Num_of_photos,
 Dense_Rank() over (order by Num_of_photos desc)Rank_Of_Tags 
 from cte;


/* Insight:- maximum No of photos associated with the tag is "Smile" with 59 Photos 
with rank1
Minimum No of photos associated with the tag is "Foodie" with 11 photos stands
 with rank 13.

/* 7.List the usernames of users who have posted photos along 
with the count of photos they have posted. 
Rank them by the number of photos in descending order. */

with cte as (  
select DISTINCT username,count(p.id) over (partition by username)Num_of_photos_posted_by_user
 from users u inner join photos p on u.id=p.user_id
 )
 select DISTINCT username,cte.Num_of_photos_posted_by_user,
 Dense_Rank() over (order by Num_of_photos_posted_by_user desc)Rank_Of_Num_of_photos 
 from cte;

/* Insight:-the max no of photos  are posted by Eveline95( 12 photos) stand at Rank1 
and least no of photos are posted is 1 photo at Rank11.  


/* 8.Display the username of each user along with the creation date of their
 first posted photo and the creation date of their next posted photo. */
 
 
select u.username,p.created_at as first_posted_photo_date,
lead(p.created_at) over (order by p.created_at) as next_posted_photo
from users u inner join photos p on u.id=p.user_id
order by next_posted_photo desc;


/* Insights:- In the short span,users have posted maximum no of photos.

 
 /* 9.For each comment, show the comment text, the username of the commenter, 
 and the comment text of the previous comment made on the same photo.  */
 
 
select comment_text as Present_comment,username,
lag(comment_text)over (order by comment_text) as Previous_comment
from comments c inner join users u  on c.user_id=u.id;

/* Insight:-We can observe the present and previous comments.



/* 10. Show the username of each user along with the number of photos they have
 posted and the number of photos posted by the user before them and 
 after them, based on the creation date. */
 
 
 
 
with cte_Num_of_photos as(
select distinct username,p.created_at,count(p.id) over (partition by username)Num_of_Photos
 from users u 
inner join photos p on u.id=p.user_id)
select distinct username,Num_of_Photos as Num_of_photos_posted,
lag(Num_of_Photos) over (order by cte_Num_of_photos.created_at)Num_of_photos_before_creation_date,
lead(Num_of_Photos) over (order by cte_Num_of_photos.created_at)Num_of_photos_after_creation_date
from cte_Num_of_photos;


/* Insight:- we can observe the num of photos,num of photos before creation date,
num of photos after creation date.
 











