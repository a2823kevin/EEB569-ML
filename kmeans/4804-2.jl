mutable struct Point
    x::Float32
    y::Float32
end

mutable struct Group
    name::String
    pivot::Point
    members::Vector{Point}
    old_members::Union{Vector{Point}, Nothing}

    Group(name, pivot) = new(name, pivot, [], nothing)
end

function distance(point1::Point, point2::Point)::Float32
    return ((point1.x-point2.x)^2 + (point1.y-point2.y)^2) ^ 0.5
end

function no_member_update(group::Group)::UInt8
    if (isnothing(group.old_members))
        return 0
    end

    if (length(group.members) != length(group.old_members))
        return 0
    end

    for member in group.members
        if !(member in group.old_members)
            return 0
        end
    end
    
    return 1
end

function update_pivot(group::Group)
    x = sum(point.x for point in group.members) / length(group.members)
    y = sum(point.y for point in group.members) / length(group.members)
    group.pivot.x = x
    group.pivot.y = y

    group.old_members = [member for member in group.members]
    group.members = []
end

function search_group(points::Vector{Point}, groups::Vector{Group})
    for point in points
        distances = [distance(point, group.pivot) for group in groups]
        push!(groups[argmin(distances)].members, point)
    end
end

function print_group_info(group::Group)
    println("【Group $(group.name)】")
    println("pivot: ($(group.pivot.x), $(group.pivot.y))")
    print("members: ")
    println(join(["($(member.x), $(member.y))" for member in group.members], ", "))
    print("\n")
end

function K_means_distance(groups::Vector{Group}, samples::Vector{Point})
    distances = Vector{Float32}()
    for group in groups
        [push!(distances, distance(member, group.pivot)) for member in group.members]
    end
    return sum(distances) / length(samples)
end

# main
# initialization
# load samples
samples = Vector{Point}()
open("sample points.csv", "r") do fin
    for ln in readlines(fin)
        val = split(ln, ',')
        p = Point(parse(Float32, val[1]), parse(Float32, val[2]))
        push!(samples, p)
    end
end

# load groups
groups = Vector{Group}()
open("grouping points.csv", "r") do fin
    for ln in readlines(fin)
        val = split(ln, ',')
        p = Point(parse(Float32, val[2]), parse(Float32, val[3]))
        g = Group(val[1], p)
        push!(groups, g)
    end
end

# search & update until no member change
iteration = -1
while (true)
    global  iteration
    iteration += 1
    println("####Iteration $iteration#####\n")

    # search
    search_group(samples, groups)
    # [print_group_info(group) for group in groups]

    #mean distance
    println("K-means distance: $(K_means_distance(groups, samples))\n")

    # check if clustering is completed
    if (sum([no_member_update(group) for group in groups])==length(groups))
        break
    end

    # update
    # calculate new pivot & move members to old members
    [update_pivot(group) for group in groups]
end