import { hash } from "@ember/helper";
import { htmlSafe } from "@ember/template";
import PluginOutlet from "discourse/components/plugin-outlet";
import SortableColumn from "discourse/components/topic-list/header/sortable-column";
import coldAgeClass from "discourse/helpers/cold-age-class";
import concatClass from "discourse/helpers/concat-class";
import formatDate from "discourse/helpers/format-date";
import { apiInitializer } from "discourse/lib/api";

const CreatedHeaderCell = <template>
  <SortableColumn
    @sortable={{@sortable}}
    @number="true"
    @order="created"
    @activeOrder={{@activeOrder}}
    @changeSort={{@changeSort}}
    @ascending={{@ascending}}
    @name="created"
  />
</template>;

const CreatedItemCell = <template>
  <td
    title={{htmlSafe @topic.bumpedAtTitle}}
    class={{concatClass
      "activity num topic-list-data"
      (coldAgeClass @topic.createdAt startDate=@topic.bumpedAt class="")
    }}
    ...attributes
  >
    <a href={{@topic.url}} class="post-activity">
      <PluginOutlet
        @name="topic-list-before-relative-date"
        @outletArgs={{hash topic=@topic}}
      />
      {{formatDate @topic.createdAt format="tiny" noTitle="true"}}
    </a>
  </td>
</template>;

export default apiInitializer("1.0", (api) => {
  api.registerValueTransformer("topic-list-columns", ({ value: columns }) => {
    columns.add("created", {
      header: CreatedHeaderCell,
      item: CreatedItemCell,
    });

    columns.delete("views");

    columns.reposition("created", { before: "activity" });

    return columns;
  });
});
