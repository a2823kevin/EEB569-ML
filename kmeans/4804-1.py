class Point:
    def __init__(self, x, y) -> None:
        self.x = x
        self.y = y

    def __str__(self) -> str:
        return f"({self.x}, {self.y})"

    def distance_to(self, point) -> float:
        return ((self.x-point.x)**2 + (self.y-point.y)**2) ** 0.5

class Group(Point):
    def __init__(self, name, x, y) -> None:
        super().__init__(x, y)
        self.name = name
        self.pivot = Point(x, y)
        self.members = []
        self.old_members = None

    def __str__(self) -> str:
        return f"【Group {self.name}】\npivot: {self.pivot}\nmembers: " + ", ".join([str(member) for member in self.members])

    def no_member_update(self) -> int:
        if (self.old_members==None):
            return 0
        return 1 if self.members==self.old_members else 0

    def update_pivot(self):
        self.pivot.x = sum([sample.x for sample in self.members]) / len(self.members)
        self.pivot.y = sum([sample.y for sample in self.members]) / len(self.members)

        self.old_members = [member for member in self.members]
        self.members.clear()

class Sample(Point):
    def __init__(self, x, y) -> None:
        super().__init__(x, y)

    def set_group(self, groups) -> None:
        # search group
        distances = {group.name:self.distance_to(group.pivot) for group in groups}
        min_dist_idx = list(distances.values()).index(min(distances.values()))
        
        # change group
        self.group = groups[min_dist_idx]
        groups[min_dist_idx].members.append(self)

if (__name__=="__main__"):
    # initialization
    # load samples
    with open("sample points.csv", "r") as fin:
        vals = [ln.split(",") for ln in fin.read().split("\n")]
        samples = [Sample(int(val[0]), int(val[1])) for val in vals]

    # load groups
    with open("grouping points.csv", "r") as fin:
        vals = [ln.split(",") for ln in fin.read().split("\n")]
        groups = [Group(val[0], int(val[1]), int(val[2])) for val in vals]

    # search & update until no member change
    iteration = -1
    while (True):
        iteration += 1
        print(f"\n{'Iteration '+str(iteration):#^20}")

        # search
        [sample.set_group(groups) for sample in samples]
        # print("\n\n".join([str(group) for group in groups]))

        #K-means distance
        print(f"\nK-means distance: {sum([sample.distance_to(sample.group.pivot) for sample in samples]) / len(samples)}")
        
        # check if clustering is completed
        if (sum([group.no_member_update() for group in groups])==len(groups)):
            break

        # update
        # calculate new pivot & move members to old members
        [group.update_pivot() for group in groups]